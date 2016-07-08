#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "cuColor.h"
#include <helper_cuda.h>
#include <cuComplex.h>
#include <curand.h>

#define MAXTHREADS 512
#define COLORDEPTH 256

double2 axes=make_double2(4, 4);
double2 origin=make_double2(-2, -2);
int2 ensemble=make_int2(200,200);

uchar4 *d_cmap;
float2 *d_points;

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

__global__ void diskPointPicking(float2* d_points, int n){
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


__global__ void blackScreen(uchar4* d_pixel, int2 image){
	int i=blockIdx.x*blockDim.x+threadIdx.x;
	int j=blockIdx.y*blockDim.y+threadIdx.y;
	if(i<image.x && j<image.y){
		int gid=j*image.y+i;
		d_pixel[gid]=make_uchar4(0x00,0x00,0x00,0xFF);
	}
}

__global__ void partiallyCoherent(uchar4* d_pixel, int2 image, uchar4* d_cmap, float2* d_points, int2 ensemble, double2 axes, double2 origin){
	int i=blockIdx.x*blockDim.x+threadIdx.x;
	int j=blockIdx.y*blockDim.y+threadIdx.y;
	if(i<image.x && j<image.y){
		int gid=j*image.y+i;

		// reference frame
		float x=fma((float)i/image.x, (float)axes.x, (float)origin.x);
		float y=fma((float)j/image.y, (float)axes.y, (float)origin.y);

		int l=1;
		float I=0.0;
		float c=0.5;
		float xp, yp, rp, tp;
		float u0, sinptr, cosptr;
		float2 uk;
		for(int k=0; k<ensemble.x; k++){
			uk=make_float2(0,0);
			for(int m=0; m<ensemble.y; m++){
				int p=k*ensemble.y+m;
				xp=fma(c, d_points[p].x, x);
				yp=fma(c, d_points[p].y, y);
				rp=hypotf(yp, xp);
				tp=atan2f(yp, xp);

				sincosf(l*tp, &sinptr, &cosptr);
				u0=powf(rp,abs(l))*expf(-rp*rp)*2.35/ensemble.y;
				uk.x=fma(u0, cosptr, uk.x);
				uk.y=fma(u0, sinptr, uk.y);
			}
			I+=(uk.x*uk.x+uk.y*uk.y);
		}

		int cindex=(int)(COLORDEPTH*I/ensemble.x);
		d_pixel[gid]=d_cmap[clamp(cindex, 0, COLORDEPTH-1)];
	}
}


void init_kernel(int2 image){
	cudaMalloc((void**)&d_cmap, COLORDEPTH*sizeof(uchar4));
	hot<<<1, COLORDEPTH>>>(d_cmap, COLORDEPTH);


	int npoints=ensemble.x*ensemble.y;
	cudaMalloc((void**)&d_points, npoints*sizeof(float2));

	unsigned long long seed=1000;

	curandGenerator_t generator;
	curandCreateGenerator(&generator, CURAND_RNG_PSEUDO_DEFAULT);
	curandSetPseudoRandomGeneratorSeed(generator, seed);
	curandGenerateUniform(generator, (float*)d_points, 2*npoints);

	const dim3 block(MAXTHREADS);
	const dim3 grid(ceil(npoints, block.x));
	diskPointPicking<<<grid,block>>>(d_points, npoints);
}

void launch_kernel(uchar4* d_pixel, int2 image, float time){
	static const dim3 block(MAXTHREADS);
	static const dim3 grid(ceil(image.x, block.x), ceil(image.y, block.y));
	static int count=0;
	if(count<60){
		blackScreen<<<grid,block>>>(d_pixel, image);
	}else if(count==60){
		partiallyCoherent<<<grid,block>>>(d_pixel, image, d_cmap, d_points, ensemble, axes, origin);
	}
	count++;
	cudaThreadSynchronize();
	checkCudaErrors(cudaGetLastError());
}
