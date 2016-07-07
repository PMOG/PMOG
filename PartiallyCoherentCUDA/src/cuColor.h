#include <cutil_math.h>

// color constants
__device__ const uchar4 black   = {0x00, 0x00, 0x00, 0xFF};
__device__ const uchar4 white   = {0xFF, 0xFF, 0xFF, 0xFF};
__device__ const uchar4 red     = {0xFF, 0x00, 0x00, 0xFF};
__device__ const uchar4 green   = {0x00, 0xFF, 0x00, 0xFF};
__device__ const uchar4 blue    = {0x00, 0x00, 0xFF, 0xFF};
__device__ const uchar4 cyan    = {0x00, 0xFF, 0xFF, 0xFF};
__device__ const uchar4 magenta = {0xFF, 0x00, 0xFF, 0x00};
__device__ const uchar4 yellow  = {0xFF, 0xFF, 0x00, 0xFF};
__device__ const uchar4 wgreen  = {0x00, 0xFF, 0x7F, 0xFF};
__device__ const uchar4 sgreen  = {0x00, 0x7F, 0x66, 0xFF};
__device__ const uchar4 syellow = {0xFF, 0xFF, 0x66, 0xFF};

// standard colormaps
__device__ const uchar4 parulamap[4]={
	{0x35, 0x2B, 0x87, 0xFF},
	{0x07, 0x9D, 0xD0, 0xFF},
	{0xA6, 0xBF, 0x6B, 0xFF},
	{0xFA, 0xFC, 0x0E, 0xFF},
};

__device__ const uchar4 jetmap[4]={
	{0x00, 0x00, 0xFF, 0xFF}, //blue
	{0x00, 0xFF, 0xFF, 0xFF}, //cyan
	{0xFF, 0xFF, 0x00, 0xFF}, //yellow
	{0xFF, 0x00, 0x00, 0xFF}, //red
};

__device__ const uchar4 hotmap[4]={
	{0x00, 0x00, 0x00, 0xFF}, //black
	{0xFF, 0x00, 0x00, 0xFF}, //red
	{0xFF, 0xFF, 0x00, 0xFF}, //yellow
	{0xFF, 0xFF, 0xFF, 0xFF}, //white
};
__device__ uchar4 lerp(uchar4 a, uchar4 b, float t){
	return make_uchar4(lerp(a.x, b.x, t),
			lerp(a.y, b.y, t),
			lerp(a.z, b.z, t),
			lerp(a.w, b.w, t));
}

__global__ void gray(uchar4 *d_cmap, int n){
	int gid=blockDim.x*blockIdx.x+threadIdx.x;
	if(gid<n){
		unsigned char gs=(256*gid)/n;
		d_cmap[gid]=make_uchar4(gs, gs, gs, 0xFF);
	}
}
__global__ void parula(uchar4 *d_cmap, int n){
	int gid=blockDim.x*blockIdx.x+threadIdx.x;
	if(gid<n){
		float t=(3.f*gid)/(n-1);
		d_cmap[gid]=lerp(parulamap[(int)t], parulamap[(int)ceil(t)], t-(int)t);
	}
}
__global__ void jet(uchar4 *d_cmap, int n){
	int gid=blockDim.x*blockIdx.x+threadIdx.x;
	if(gid<n){
		float t=(3.f*gid)/(n-1);
		d_cmap[gid]=lerp(jetmap[(int)t], jetmap[(int)ceil(t)], t-(int)t);
	}
}
__global__ void hot(uchar4 *d_cmap, int n){
	int gid=blockDim.x*blockIdx.x+threadIdx.x;
	if(gid<n){
		float t=(3.f*gid)/(n-1);
		d_cmap[gid]=lerp(hotmap[(int)t], hotmap[(int)ceil(t)], t-(int)t);
	}
}
__global__ void cool(uchar4 *d_cmap, int n){
	int gid=blockDim.x*blockIdx.x+threadIdx.x;
	if(gid<n){
		d_cmap[gid]=lerp(cyan, magenta, (float)gid/(n-1));
	}
}
__global__ void spring(uchar4 *d_cmap, int n){
	int gid=blockDim.x*blockIdx.x+threadIdx.x;
	if(gid<n){
		d_cmap[gid]=lerp(magenta, yellow, (float)gid/(n-1));
	}
}
__global__ void summer(uchar4 *d_cmap, int n){
	int gid=blockDim.x*blockIdx.x+threadIdx.x;
	if(gid<n){
		d_cmap[gid]=lerp(sgreen, syellow, (float)gid/(n-1));
	}
}
__global__ void autumn(uchar4 *d_cmap, int n){
	int gid=blockDim.x*blockIdx.x+threadIdx.x;
	if(gid<n){
		d_cmap[gid]=lerp(red, yellow, (float)gid/(n-1));
	}
}
__global__ void winter(uchar4 *d_cmap, int n){
	int gid=blockDim.x*blockIdx.x+threadIdx.x;
	if(gid<n){
		d_cmap[gid]=lerp(blue, wgreen, (float)gid/(n-1));
	}
}
