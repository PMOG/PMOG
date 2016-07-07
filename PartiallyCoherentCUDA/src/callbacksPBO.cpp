// callbacksPBO.cpp adapted from Rob Farber's code from drdobbs.com

#include <GL/glew.h>
#include <GL/freeglut.h>
#include <cuda_runtime.h>
#include <helper_cuda.h>
#include <helper_cuda_gl.h>
#include <cutil_math.h>
#include <cuda_gl_interop.h>
#include <rendercheck_gl.h>

//external variables
extern GLuint pbo;
extern GLuint textureID;
extern int2 image;
extern double2 axes;
extern double2 origin;

// variables for keyboard control
int animFlag = 1;
float animTime = 0.0f;
float animInc = 0.01f;

// variables for mouse control
int2 window;
int2 mousePos;
int2 poi={0,0};
int2 roi=image;


// The user must create the following routines:
void runCuda();

void zoom(int x, int y, double z){
	origin.x+=(1-z)*axes.x*(poi.x+(double)(x*roi.x)/window.x)/image.x;
	origin.y+=(1-z)*axes.y*(poi.y+(double)(y*roi.y)/window.y)/image.y;
	axes.x*=z;
	axes.y*=z;
}
void setROI(int x, int y, double z){
	poi.x+=((1-z)*(x*roi.x))/window.x;
	poi.y+=((1-z)*(y*roi.y))/window.y;
	roi.x=clamp(z*roi.x, 1, image.x);
	roi.y=clamp(z*roi.y, 1, image.y);
	if(poi.x<0){
		poi.x=0;
	}else if(poi.x+roi.x>image.x){
		poi.x=image.x-roi.x;
	}
	if(poi.y<0){
		poi.y=0;
	}else if(poi.y+roi.y>image.y){
		poi.y=image.y-roi.y;
	}
}

// Callbacks for GLUT
void display(){
	// run CUDA kernel
	runCuda();

	// Create a texture from the buffer
	glBindBuffer(GL_PIXEL_UNPACK_BUFFER, pbo);

	// bind texture from PBO
	glBindTexture(GL_TEXTURE_RECTANGLE_ARB, textureID);

	// Note: glTexSubImage2D will perform a format conversion if the
	// buffer is a different format from the texture. We created the
	// texture with format GL_RGBA8. In glTexSubImage2D we specified
	// GL_BGRA and GL_UNSIGNED_INT. This is a fast-path combination

	// Note: NULL indicates the data resides in device memory
	glTexSubImage2D(GL_TEXTURE_RECTANGLE_ARB, 0, 0, 0, image.x, image.y,
		GL_RGBA, GL_UNSIGNED_BYTE, NULL);

	// Draw a single Quad with texture coordinates for each vertex.
	glBegin(GL_QUADS);
	glTexCoord2i(poi.x,       poi.y);		glVertex3f(0.0f, 0.0f, 0.0f);
	glTexCoord2i(poi.x+roi.x, poi.y);		glVertex3f(1.0f, 0.0f, 0.0f);
	glTexCoord2i(poi.x+roi.x, poi.y+roi.y);	glVertex3f(1.0f, 1.0f, 0.0f);
	glTexCoord2i(poi.x,       poi.y+roi.y);	glVertex3f(0.0f, 1.0f, 0.0f);
	glEnd();

	// Don't forget to swap the buffers!
	glutSwapBuffers();
	glutReportErrors();

	// if animFlag is true, then indicate the display needs to be redrawn
	if(animFlag){
		glutPostRedisplay();
		animTime+=animInc;
	}
}
void reshape(int w, int h){
	window=make_int2(w,h);
	glViewport(0, 0, w, h);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrtho(0.0, 1.0, 0.0, 1.0, 0.0, 1.0);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
}
void keyPressed(unsigned char key, int x, int y){
	switch(key){
	case 27:
		exit(0);
		break;
	case 'z':
		zoom(x, window.y-y, 0.920);
		break;
	case 'x':
		zoom(x, window.y-y, 1.087);
		break;
	case 'q':
		setROI(x, window.y-y, 0.5);
		break;
	case 'e':
		setROI(x, window.y-y, 2.0);
		break;
	case 'w':
		poi.y=min(poi.y+(roi.y+31)/32, image.y-roi.y);
		break;
	case 'a':
		poi.x=max(poi.x-(roi.x+31)/32, 0);
		break;
	case 's':
		poi.y=max(poi.y-(roi.y+31)/32, 0);
		break;
	case 'd':
		poi.x=min(poi.x+(roi.x+31)/32, image.x-roi.x);
		break;
	case 32: // toggle animation
		animFlag=!animFlag;
		break;
	case '-': // decrease the time increment for the CUDA kernel
		animInc-=0.01f;
		break;
	case '+': // increase the time increment for the CUDA kernel
		animInc+=0.01f;
		break;
	case 'r': // reset the time increment 
		animInc=0.01f;
		break;
	}

	// indicate the display must be redrawn
	glutPostRedisplay();
}
void keyReleased(unsigned char key, int x, int y){

}
void mouseButton(int button, int state, int x, int y){
	mousePos.x=x;
	mousePos.y=y;
}
void mouseMotion(int x, int y){
	origin.x-=(x-mousePos.x)*roi.x*axes.x/(image.x*window.x);
	origin.y+=(y-mousePos.y)*roi.y*axes.y/(image.y*window.y);
	mousePos.x=x;
	mousePos.y=y;
}
void timerEvent(int value){
	glutPostRedisplay();
	glutTimerFunc(10, timerEvent, 0);
}
void idle(){
	glutPostRedisplay();
}
