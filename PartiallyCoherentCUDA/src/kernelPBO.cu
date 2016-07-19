#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "cuColor.h"
#include <helper_cuda.h>
#include <cuComplex.h>
#include <curand.h>

#include <thrust/device_vector.h>
#include <thrust/reduce.h>
#include <float.h>

using namespace thrust;

#define MAXTHREADS 512
#define COLORDEPTH 256
#define WEIGHT 2

double2 axes=make_double2(4, 4);
double2 origin=make_double2(-2, -2);
int2 ensemble=make_int2(200,200);

uchar4 *d_cmap;
float3 *d_points;
float2 *d_field;
float *d_intensity;
float *d_chi;

inline int ceil(int num, int den){
	return (num+den-1)/den;
}

__host__ __device__ float LaguerreL(float* a, int n, float alpha, float x){
	float temp, yy=0;
	float y=(n>1)?a[n-1]:0;
	for(int k=n-2; k>0; k--){
		temp=y;
		y=a[k]+(2*k+1+alpha-x)/(k+1)*y-(k+1+alpha)/(k+2)*yy;
		yy=temp;
	}
	return a[0]+(1+alpha-x)*y-(1+alpha)*yy/2;
}

__global__ void diskPointPicking(int n, float3* d_points){
	// maps [0,1]^2 to the unit disk
	int i=blockIdx.x*blockDim.x+threadIdx.x;
	if(i<n){
		float r=sqrtf(d_points[i].x);
		float sinptr, cosptr;
		sincospif(2*d_points[i].y, &sinptr, &cosptr);
		d_points[i].x=r*cosptr;
		d_points[i].y=r*sinptr;
	}
}

__global__ void ensembleMember(int2 image, uchar4 *d_pixel, uchar4* d_cmap, float3 *d_points, float2 *d_field, float *d_intensity, int k, int2 ensemble, double2 axes, double2 origin){
	int i=blockIdx.x*blockDim.x+threadIdx.x;
	int j=blockIdx.y*blockDim.y+threadIdx.y;
	if(i<image.x && j<image.y){
		int gid=j*image.x+i;

		// reference frame
		float x=fma((float)i/image.x, (float)axes.x, (float)origin.x);
		float y=fma((float)j/image.y, (float)axes.y, (float)origin.y);

		int l=1;
		float c=0.7;
		float xp, yp, rp, tp, u0, sinptr, cosptr;
		float2 uk=make_float2(0,0);
		for(int m=0; m<ensemble.y; m++){
			int p=k*ensemble.y+m;
			xp=fma(c, d_points[p].x, x);
			yp=fma(c, d_points[p].y, y);
			rp=hypotf(yp, xp);
			tp=atan2f(yp, xp);

			sincosf(l*tp+2*M_PI*d_points[p].z, &sinptr, &cosptr);
			u0=powf(rp,abs(l))*expf(-rp*rp);
			uk.x=fma(u0, cosptr, uk.x);
			uk.y=fma(u0, sinptr, uk.y);
		}
		float uu=uk.x*uk.x+uk.y*uk.y;
		d_field[gid]=uk;
		d_intensity[gid]+=uu;
		int cid=clamp((int)((COLORDEPTH-1)*WEIGHT*uu/ensemble.y), 0, COLORDEPTH-1);
		d_pixel[gid]=d_cmap[cid];
	}
}

__global__ void crossCorrelation(int2 image, float* d_chi, float2* d_field){
	int i=blockIdx.x*blockDim.x+threadIdx.x;
	int j=blockIdx.y*blockDim.y+threadIdx.y;
	if(i<image.x && j<image.y){
		int gid=j*image.x+i;
		int rid=(image.y-1-j)*image.x+(image.x-1-i); // rotated index
		d_chi[gid]+=d_field[gid].x*d_field[rid].x+d_field[gid].y*d_field[rid].y;
	}
}

__global__ void imagesc(int2 image, uchar4* d_pixel, uchar4* d_cmap, float *d_X, float xmin, float xmax){
	int i=blockIdx.x*blockDim.x+threadIdx.x;
	int j=blockIdx.y*blockDim.y+threadIdx.y;
	if(i<image.x && j<image.y){
		int gid=j*image.x+i;
		int cid=clamp((int)(COLORDEPTH*(d_X[gid]-xmin)/(xmax-xmin)), 0, COLORDEPTH-1);
		d_pixel[gid]=d_cmap[cid];
	}
}

void init_kernel(int2 image){
	// Initialize colormap
	cudaMalloc((void**)&d_cmap, COLORDEPTH*sizeof(uchar4));
	gray<<<1, COLORDEPTH>>>(d_cmap, COLORDEPTH);

	// Allocate field, intensity, and cross-correlation
	int npixels=image.x*image.y;
	cudaMalloc((void**)&d_field, npixels*sizeof(float2));
	cudaMalloc((void**)&d_intensity, npixels*sizeof(float));
	cudaMemset(d_intensity, 0, npixels*sizeof(float));
	cudaMalloc((void**)&d_chi, npixels*sizeof(float));
	cudaMemset(d_chi, 0, npixels*sizeof(float));

	// Allocate points
	int npoints=ensemble.x*ensemble.y;
	cudaMalloc((void**)&d_points, npoints*sizeof(float3));

	// Generate random distribution
	unsigned long long seed=1000;
	curandGenerator_t generator;
	curandCreateGenerator(&generator, CURAND_RNG_PSEUDO_DEFAULT);
	curandSetPseudoRandomGeneratorSeed(generator, seed);
	curandGenerateUniform(generator, (float*)d_points, 3*npoints);

	// Map to unit disk
	const dim3 block(MAXTHREADS);
	const dim3 grid(ceil(npoints, block.x));
	diskPointPicking<<<grid,block>>>(npoints, d_points);
}

void launch_kernel(int2 image, uchar4* d_pixel, float time){
	static const dim3 block(MAXTHREADS);
	static const dim3 grid(ceil(image.x, block.x), ceil(image.y, block.y));
	static const int npixels=image.x*image.y;
	static const device_ptr<float> t_chi(d_chi);
	static const device_ptr<float> t_intensity(d_intensity);
	static int k=0;

	if(k<ensemble.x){
		ensembleMember<<<grid,block>>>(image, d_pixel, d_cmap, d_points, d_field, d_intensity, k, ensemble, axes, origin);
		crossCorrelation<<<grid,block>>>(image, d_chi, d_field);
		k++;
	}else{
		float chimin = reduce(t_chi, t_chi+npixels,  FLT_MAX, minimum<float>());
		float chimax = reduce(t_chi, t_chi+npixels, -FLT_MAX, maximum<float>());
		imagesc<<<grid,block>>>(image, d_pixel, d_cmap, d_chi, chimin, chimax);
	}

	cudaThreadSynchronize();
	checkCudaErrors(cudaGetLastError());
}
