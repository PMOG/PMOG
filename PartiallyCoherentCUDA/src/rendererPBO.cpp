// simplePBO.cpp adapted from Rob Farber's code from drdobbs.com

#include <GL/glew.h>
#include <GL/gl.h>
#include <GL/glext.h>
#include <cuda_runtime.h>
#include <helper_cuda.h>
#include <cuda_gl_interop.h>

// external variables
extern float animTime;

// constants (the following should be a const in a header file)
int2 image={1<<10, 1<<10};

void init_kernel(int2 image);
void launch_kernel(int2 image, uchar4* d_pixel, float time);

// variables
GLuint pbo;
GLuint textureID;

void createPBO(GLuint* pbo, int2 size){
	if(pbo){
		// set up vertex data parameter
		int size_tex_data = size.x*size.y*sizeof(uchar4);
		// Generate a buffer ID called a PBO (Pixel Buffer Object)
		glGenBuffers(1, pbo);
		// Make this the current UNPACK buffer (OpenGL is state-based)
		glBindBuffer(GL_PIXEL_UNPACK_BUFFER, *pbo);
		// Allocate data for the buffer. 4-channel 8-bit image
		glBufferData(GL_PIXEL_UNPACK_BUFFER, size_tex_data, NULL, GL_DYNAMIC_COPY);
		cudaGLRegisterBufferObject(*pbo);
	}
}

void deletePBO(GLuint* pbo){
	if(pbo){
		// unregister this buffer object with CUDA
		cudaGLUnregisterBufferObject(*pbo);
		glBindBuffer(GL_ARRAY_BUFFER, *pbo);
		glDeleteBuffers(1, pbo);
		pbo=NULL;
	}
}

void createTexture(GLuint* textureID, int2 size){
	// Enable Texturing
	glEnable(GL_TEXTURE_RECTANGLE_ARB);

	// Generate a texture identifier
	glGenTextures(1, textureID);

	// Make this the current texture (remember that GL is state-based)
	glBindTexture(GL_TEXTURE_RECTANGLE_ARB, *textureID);

	// Allocate the texture memory. The last parameter is NULL since we only
	// want to allocate memory, not initialize it
	glTexImage2D(GL_TEXTURE_RECTANGLE_ARB, 0, GL_RGBA8, size.x, size.y, 0,
		GL_BGRA, GL_UNSIGNED_BYTE, NULL);

	// Must set the filter mode, GL_LINEAR enables interpolation when scaling
	glTexParameteri(GL_TEXTURE_RECTANGLE_ARB, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_RECTANGLE_ARB, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

	// Note: GL_TEXTURE_RECTANGLE_ARB may be used instead of
	// GL_TEXTURE_2D for improved performance if linear interpolation is
	// not desired. Replace GL_LINEAR with GL_NEAREST in the
	// glTexParameteri() call
}

void deleteTexture(GLuint* tex){
	glDeleteTextures(1, tex);
	tex=NULL;
	delete tex;
}

void cleanupCuda(){
	if(pbo){
		deletePBO(&pbo);
	}
	if(textureID){
		deleteTexture(&textureID); 
	}
}

// Run the Cuda part of the computation
void runCuda(){
	uchar4 *d_pixel=NULL;

	// map OpenGL buffer object for writing from CUDA on a single GPU
	// no data is moved (Win & Linux). When mapped to CUDA, OpenGL
	// should not use this buffer
	cudaGLMapBufferObject((void**)&d_pixel, pbo);

	// execute the kernel
	launch_kernel(image, d_pixel, animTime);

	// unmap buffer object
	cudaGLUnmapBufferObject(pbo);
}

void initCuda(int argc, char** argv){
	// First initialize OpenGL context, so we can properly set the GL
	// for CUDA.  NVIDIA notes this is necessary in order to achieve
	// optimal performance with OpenGL/CUDA interop.  use command-line
	// specified CUDA device, otherwise use device with highest Gflops/s
	cudaGLSetGLDevice(findCudaDevice(argc, (const char **)argv));
	createPBO(&pbo, image);
	createTexture(&textureID, image);

	// Clean up on program exit
	atexit(cleanupCuda);

	init_kernel(image);
	runCuda();
}
