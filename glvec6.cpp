#include "glvec6.hpp"



GLfloat GLvec6::pos() {
		return sqrt(x*x + y*y + z*z);
	}
	
	
GLvec6 midpoint(GLvec6 a, GLvec6 b) {
	GLvec6 c;
	c.x = 0.5 * (a.x + b.x);
	c.y = 0.5 * (a.y + b.y);
	c.z = 0.5 * (a.z + b.z);
	c.r = .6;
	c.g = .5;
	c.b = .3;
	return c;
}
