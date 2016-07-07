// PixelMain.cpp adapted from Rob Farber's code from drdobbs.com

#include <GL/glew.h>
#include <GL/freeglut.h>
#include <cuda_runtime.h>
#include <cuda_gl_interop.h>
#include <helper_cuda.h>
#include <helper_cuda_gl.h>
#include <helper_timer.h>

// The user must create the following routines:
// CUDA methods
extern void initCuda(int argc, char** argv);

// callbacks
extern void display();
extern void reshape(int, int);
extern void keyPressed(unsigned char, int, int);
extern void keyReleased(unsigned char, int, int);
extern void mouseButton(int, int, int, int);
extern void mouseMotion(int, int);
extern void timerEvent(int);
extern void idle();

// Timer for FPS calculations
StopWatchInterface *timer = NULL; 

// Simple method to display the Frames Per Second in the window title
void computeFPS(){
	static int fpsCount=0;
	static int fpsLimit=60;
	if(++fpsCount==fpsLimit){
		float ifps=1000.f/sdkGetAverageTimerValue(&timer);	
		char fps[256];
		sprintf(fps, "Cuda GL Interop Wrapper: %3.1f fps ", ifps);
		glutSetWindowTitle(fps);
		fpsCount=0;
		fpsLimit=ifps>1.f? (int)ifps: 1;
		sdkResetTimer(&timer);
	}
}

void fpsDisplay(){
	sdkStartTimer(&timer);
	display();
	sdkStopTimer(&timer);
	computeFPS();
}

bool initGL(int* argc, char **argv){
	// create a window and GL context (also register callbacks)
	glutInit(argc, argv);
	glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE);
	glutInitWindowSize(720, 720);
	glutInitWindowPosition(0, 0);
	glutCreateWindow("Cuda GL Interop Wrapper (adapted from NVIDIA's simpleGL)");
	
	// register callbacks
	glutDisplayFunc(fpsDisplay);
	glutReshapeFunc(reshape);
	glutKeyboardFunc(keyPressed);
	glutKeyboardUpFunc(keyReleased);
	glutMouseFunc(mouseButton);
	glutMotionFunc(mouseMotion);
	glutTimerFunc(10, timerEvent, 0);
	glutIdleFunc(idle);

	// check for necessary OpenGL extensions
	glewInit();
	if(!glewIsSupported("GL_VERSION_2_0 ")) {
		fprintf(stderr, "ERROR: Support for necessary OpenGL extensions missing.");
		fflush(stderr);
		return false;
	}

	// default initialization
	glClearColor(0.0, 0.0, 0.0, 1.0);
	glDisable(GL_DEPTH_TEST);

	return true;
}

// Main program
int main(int argc, char** argv){
	sdkCreateTimer(&timer);

	if(!initGL(&argc, argv)){
		exit(EXIT_FAILURE);
	}

	initCuda(argc, argv);
	SDK_CHECK_ERROR_GL();
	
	// start rendering mainloop
	glutMainLoop();

	// clean up
	sdkDeleteTimer(&timer);
	cudaThreadExit();
	exit(EXIT_SUCCESS);
}
