#include <GL/gl.h>
#define GLEW_STATIC
#include <GL/glew.h>
#include <math.h>
#include "triangles.hpp"
#include "glvec6.hpp"
std::vector<GLfloat> triangles;
void drawTriangle(GLvec6 v1, GLvec6 v2, GLvec6 v3, GLuint &VAO, GLuint &VBO){
	
	triangles.push_back(v1.x);
    triangles.push_back(v1.y);
    triangles.push_back(v1.z);
    triangles.push_back(v1.r);
    triangles.push_back(v1.g);
    triangles.push_back(v1.b);
    triangles.push_back(v2.x);
    triangles.push_back(v2.y);
    triangles.push_back(v2.z);
    triangles.push_back(v2.r);
    triangles.push_back(v2.g);
    triangles.push_back(v2.b);
    triangles.push_back(v3.x);
    triangles.push_back(v3.y);
    triangles.push_back(v3.z);
    triangles.push_back(v3.r);
    triangles.push_back(v3.g);
    triangles.push_back(v3.b);
}

void subdivide(GLvec6 v1, GLvec6 v2, GLvec6 v3, GLuint &VAO, GLuint &VBO, int level) {
	if (level == 0) {
		drawTriangle(v1, v2, v3, VAO, VBO);
	}
	else {
		GLvec6 v12 = midpoint(v1, v2);
		GLvec6 v13 = midpoint(v1, v3);
		GLvec6 v23 = midpoint(v2, v3);
		float s = 1.0f/ (float)v12.pos();
		v12.x *= s;
		v12.y *= s;
		v12.z *= s;
		s = 1.0f/(float)v13.pos();
		v13.x *= s;
		v13.y *= s;
		v13.z *= s;
		s = 1.0f/(float)v23.pos();
		v23.x *= s;
		v23.y *= s;
		v23.z *= s;
		subdivide(v1, v12, v13, VAO, VBO, level -1);
		subdivide(v12, v2, v23, VAO, VBO, level - 1);
        subdivide(v13, v23, v3, VAO, VBO, level - 1);
        subdivide(v12, v23, v13, VAO, VBO, level - 1);
		
	}
}

void createSphere(GLuint &VAO, GLuint &VBO, int prec) {
	GLvec6 v1, v2, v3;
    v1.x = 0.0;
    v1.y = 1.0;
    v1.z = 0.0;
    v1.r = .6;
    v1.g = .5;
    v1.b = .3;
    
    v2.x = 1.0;
    v2.y = 0.0;
    v2.z = 0.0;
    v2.r = .6;
    v2.g = .5;
    v2.b = .3;
    
    v3.x = 0.0;
    v3.y = 0.0;
    v3.z = 1.0;
    v3.r = .6;
    v3.g = .5;
    v3.b = .3;
    
    
    subdivide(v1, v2, v3, VAO, VBO, prec);
    
    v1.x = 0.0;
    v1.y = 1.0;
    v1.z = 0.0;
    v1.r = .6;
    v1.g = .5;
    v1.b = .3;
    
    v2.x = -1.0;
    v2.y = 0.0;
    v2.z = 0.0;
    v2.r = .6;
    v2.g = .5;
    v2.b = .3;
    
    v3.x = 0.0;
    v3.y = 0.0;
    v3.z = 1.0;
    v3.r = .6;
    v3.g = .5;
    v3.b = .3;
    
    
    subdivide(v1, v2, v3, VAO, VBO, prec);
    v1.x = 0.0;
    v1.y = -1.0;
    v1.z = 0.0;
    v1.r = .6;
    v1.g = .5;
    v1.b = .3;
    
    v2.x = 1.0;
    v2.y = 0.0;
    v2.z = 0.0;
    v2.r = .6;
    v2.g = .5;
    v2.b = .3;
    
    v3.x = 0.0;
    v3.y = 0.0;
    v3.z = 1.0;
    v3.r = 0.6;
    v3.g = 0.5;
    v3.b = 0.3;
    
    subdivide(v1, v2, v3, VAO, VBO, prec);
    v1.x = 0.0;
    v1.y = -1.0;
    v1.z = 0.0;
    v1.r = .6;
    v1.g = .5;
    v1.b = .3;
    
    v2.x = -1.0;
    v2.y = 0.0;
    v2.z = 0.0;
    v2.r = 0.6;
    v2.g = 0.5;
    v2.b = 0.3;
    
    v3.x = 0.0;
    v3.y = 0.0;
    v3.z = 1.0;
    v3.r = 0.6;
    v3.g = 0.5;
    v3.b = 0.3;
    
    
    subdivide(v1, v2, v3, VAO, VBO, prec);
    
    v1.x = 0.0;
    v1.y = 1.0;
    v1.z = 0.0;
    v1.r = .6;
    v1.g = .5;
    v1.b = .3;
    
    v2.x = 1.0;
    v2.y = 0.0;
    v2.z = 0.0;
    v2.r = 0.6;
    v2.g = 0.5;
    v2.b = 0.3;
    
    v3.x = 0.0;
    v3.y = 0.0;
    v3.z = -1.0;
    v3.r = 0.6;
    v3.g = 0.5;
    v3.b = 0.3;
    
    
    subdivide(v1, v2, v3, VAO, VBO, prec);
    
    v1.x = 0.0;
    v1.y = 1.0;
    v1.z = 0.0;
    v1.r = .6;
    v1.g = .5;
    v1.b = .3;
    
    v2.x = -1.0;
    v2.y = 0.0;
    v2.z = 0.0;
    v2.r = .6;
    v2.g = .5;
    v2.b = .3;
    
    v3.x = 0.0;
    v3.y = 0.0;
    v3.z = -1.0;
    v3.r = .6;
    v3.g = .5;
    v3.b = .3;
    
    subdivide(v1, v2, v3, VAO, VBO, prec);
    v1.x = 0.0;
    v1.y = -1.0;
    v1.z = 0.0;
    v1.r = 0.6;
    v1.g = 0.5;
    v1.b = 0.3;
    
    v2.x = 1.0;
    v2.y = 0.0;
    v2.z = 0.0;
    v2.r = 0.6;
    v2.g = 0.5;
    v2.b = 0.3;
    
    v3.x = 0.0;
    v3.y = 0.0;
    v3.z = -1.0;
    v3.r = 0.6;
    v3.g = 0.5;
    v3.b = 0.3;
    
    subdivide(v1, v2, v3, VAO, VBO, prec);
    v1.x = 0.0;
    v1.y = -1.0;
    v1.z = 0.0;
    v1.r = 0.6;
    v1.g = 0.5;
    v1.b = 0.3;
    
    v2.x = -1.0;
    v2.y = 0.0;
    v2.z = 0.0;
    v2.r = 0.6;
    v2.g = 0.5;
    v2.b = 0.3;
    
    v3.x = 0.0;
    v3.y = 0.0;
    v3.z = -1.0;
    v3.r = 0.6;
    v3.g = 0.5;
    v3.b = 0.3;
    
    
    subdivide(v1, v2, v3, VAO, VBO, prec);
    glBufferData(GL_ARRAY_BUFFER,  sizeof(triangles) * triangles.size(), &triangles[0], GL_STREAM_DRAW);
    
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6  * sizeof(GLfloat), (GLvoid*)0);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(GLfloat), (GLvoid*)(3 * sizeof(GLfloat)));
    glEnableVertexAttribArray(1);
	
	
}
