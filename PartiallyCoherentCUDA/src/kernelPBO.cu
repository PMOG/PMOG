#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "cuColor.h"
#include <helper_cuda.h>
#include <cuComplex.h>

#define MAXTHREADS 512
#define COLORDEPTH 512

uchar4 *d_cmap;
double2 axes=make_double2(4, 4);
double2 origin=make_double2(-2, -2);

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

__global__ void partiallyCoherent(uchar4* d_pixel, int2 image, uchar4* d_cmap, double2 origin, double2 axes, int2 ensemble){
	int i=blockIdx.x*blockDim.x+threadIdx.x;
	int j=blockIdx.y*blockDim.y+threadIdx.y;
	if(i<image.x && j<image.y){
		int gid=j*image.y+i;

		// reference frame
		float x=fma((float)i/image.x, (float)axes.x, (float)origin.x);
		float y=fma((float)j/image.y, (float)axes.y, (float)origin.y);

		float I=0;
		float c=0.2;
		float xk, yk, rk;
		for(int k=0; k<ensemble.x; k++){
			xk=x+c*cospi((2*k)/(float)ensemble.x);
			yk=y+c*sinpi((2*k)/(float)ensemble.x);
			rk=sqrtf(xk*xk+yk*yk);
			I+=rk*exp(-rk*rk)*2/ensemble.x;
		}


		int k=(int)(COLORDEPTH*I);
		d_pixel[gid]=d_cmap[clamp(k, 0, COLORDEPTH-1)];
	}
}


void init_kernel(int2 image){
	checkCudaErrors(cudaMalloc((void**)&d_cmap, COLORDEPTH*sizeof(uchar4)));
	gray<<<1, COLORDEPTH>>>(d_cmap, COLORDEPTH);
}

void launch_kernel(uchar4* d_pixel, int2 image, float time){
	static const dim3 block(MAXTHREADS);
	static const dim3 grid(ceil(image.x, block.x), ceil(image.y, block.y));
	static const int2 ensemble={16,2};

	partiallyCoherent<<<grid,block>>>(d_pixel, image, d_cmap, origin, axes, ensemble);

	cudaThreadSynchronize();
	checkCudaErrors(cudaGetLastError());
}
