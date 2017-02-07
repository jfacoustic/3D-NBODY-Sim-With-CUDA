#ifndef GLVEC6_H
#define GLVEC6_H
#include <cmath>
#include <GL/gl.h>


class GLvec6 {
	public:
	GLfloat x, y, z, r, g, b;
	GLfloat pos(); 
};


GLvec6 midpoint(GLvec6 a, GLvec6 b); 
#endif
