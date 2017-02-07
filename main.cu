#include <cuda.h>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <vector>
#include "ShaderClass.hpp"
#include <iostream>
#include <cuda.h>
#include <curand.h>
#include <curand_kernel.h>
#include <math.h>
#include <time.h>
#include <cstdlib>
#include "initializeScreen.hpp"
#include "glvec6.hpp"
#include "particles.hpp"
#include "spheres.hpp"
#include "camera.hpp"
//GLEW
#define GLEW_STATIC
#include <GL/glew.h>

//GLFW
#include <GLFW/glfw3.h>

#define n 1000
#define G 0.00000000000667408
#define dt 60*60
#define len 1000000.0
using namespace std;

GLfloat deltaTime = 0.0f;
GLfloat lastFrame = 0.0f;



GLuint screenWidth = 1.2 * 800;
GLuint screenHeight = 1.2 * 600;

int N = 0;




__device__ void move(particle &a, float3 accel) {
	a.x.x = a.x.x + a.v.x * dt;
	a.x.y = a.x.y + a.v.y * dt;
	a.x.z = a.x.z + a.v.z * dt;
	a.v.x = a.v.x + accel.x * dt;
	a.v.y = a.v.y + accel.y * dt;
	a.v.z = a.v.z + accel.z * dt;

}

__device__ float3 gravity(particle a, particle b) {
	float3 r = {b.x.x - a.x.x, b.x.y - a.x.y, b.x.z - a.x.z};
	float rabs = sqrt(r.x * r.x + r.y * r.y + r.z * r.z);
	float temp = G * b.m / (rabs * rabs * rabs);
	float3 accel = {temp*r.x, temp*r.y, temp*r.z};

	return accel;
}



void initializeParticles(particle *a) {
	for(int i = 0; i < n; i++) {
		bool works = false;
		while (!works) {
		a[i].m = 1.0f;
		a[i].x.x = -20.0f + static_cast <float> (rand()) / static_cast<float> (RAND_MAX /(40.0f));
		a[i].x.y = -20.0f + static_cast <float> (rand()) / static_cast<float> (RAND_MAX / 40.0f);
		a[i].x.z = -20.0f + static_cast <float> (rand()) / static_cast<float> (RAND_MAX / 40.0f);
		a[i].v.x = 0.0f;
		a[i].v.y = 0.0f;
		a[i].v.z = 0.0f;
		if (a[i].x.x * a[i].x.x + a[i].x.y * a[i].x.y + a[i].x.z * a[i].x.z < 20 * 20) works = true;
		}
	}
}

__global__ void updateParticles(particle *a) {
	int tid = threadIdx.x + blockIdx.x * blockDim.x;
	while (tid < n) {
		float3 accel = {0.0, 0.0, 0.0};
		for (int i = 0; i < n; i ++) {
			if (i != tid) {

				float3 temp = gravity(a[tid], a[i]);
				accel.x += temp.x;
				accel.y += temp.y;
				accel.z += temp.z;
			}
		}
		move(a[tid], accel);
		tid += gridDim.x;
	}
}

void key_callback(GLFWwindow * window, int key, int scancode, int action, int mode);
void mouse_callback(GLFWwindow* window, double xpos, double ypos);
void scroll_callback(GLFWwindow *window, double xoffset, double yoffset);
void do_movement();

Camera camera(glm::vec3(0.0f, 0.0f, 10.0f));
GLfloat lastX = screenWidth / 2.0;
GLfloat lastY = screenHeight / 2.0;
bool keys[1024];

int main() {
	GLFWwindow * window;
	initilizeScreen(window, screenWidth, screenHeight);
    
    
    
    glewExperimental = GL_TRUE; //Ensures Glew uses modern techniques for managing OGL
    if (glewInit() != GLEW_OK)
    {
        std::cout << "Failed to initialize GLEW" << std::endl;
        return -1;
    }
    
    GLint nrAttributes;
    glGetIntegerv(GL_MAX_VERTEX_ATTRIBS, &nrAttributes );
    std::cout << "Vertex Attributes: " << nrAttributes << std::endl;
    
    
    //register callback functions after window created but before game loop!
    glfwSetKeyCallback(window, key_callback);
    glfwSetCursorPosCallback(window, mouse_callback);
    glfwSetScrollCallback(window, scroll_callback);

    glViewport(0, 0, screenWidth, screenHeight); //location of lower left corner followed by width and height
    
    Shader ourShader("vertex.shader" , "fragment.shader");
    GLuint VAO, VBO;
    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);
    glBindVertexArray(VAO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    
    int prec = 3;

    
    createSphere(VAO, VBO, prec);
    
    Shader lightingShader("lightingVertex.shader", "lightingFragment.shader");
    Shader lampShader("lampVertex.shader", "lampFragment.shader");
    
    
    particle *a;
	a = (particle*)malloc(n*sizeof(particle) );
	/*
	a[0].m = 3.0f;
	a[1].m = 1.0f;
	a[0].x.x = 0;
	a[0].x.y = 0;
	a[0].x.z = 0;
	a[0].v.x = 0.0f;
	a[0].v.y = 0;
	a[0].v.z = 0;
	a[1].x.x = 2.5f;
	a[1].x.y = 0;
	a[1].x.z = 1.0f;
	a[1].v.x = 3.0f;
	a[1].v.y = 1.5f;
	a[1].v.z = 0;
	a[2].x.x = -5.0f;
	a[2].x.y = 0.0f;
	a[2].x.z = 0.0f;
	a[2].v.x = 0.0f;
	a[2].v.y = -1.5f;
	a[2].v.z = 0.0f;
	a[2].m = 1.0f;*/
	initializeParticles(a);
	
	
	for (int i = 0; i < n; i++) {
		float3 accel = {0.0f, 0.0f, 0.0f};
		for (int j = 0; j < n; j++) {
			if(i != j) {
				float rx = a[j].x.x - a[i].x.x;
				float ry = a[j].x.y - a[i].x.y;
				float rz = a[j].x.z - a[i].x.z;
				float r = sqrt(pow((rx),2) + pow(ry,2) + pow(rz,2));
				accel.x += G * a[j].m * rx / (r*r*r);
				
				accel.y += G * a[j].m * ry / (r*r*r);
				
				accel.z += G * a[j].m * rz / (r*r*r);
			}
			a[i].v.x += accel.x * dt / 2.0f;
			a[i].v.y += accel.y * dt / 2.0f;
			a[i].v.z += accel.z * dt / 2.0f;
		}
	}
	
	particle *a_dev;
	cudaMalloc((void**)&a_dev, sizeof(particle) * n);
	cudaMemcpy(a_dev, a, sizeof(particle) *n, cudaMemcpyHostToDevice);
    //initializeParticles<<<128,128>>>(a);
	//cudaMemcpy(a, a_dev, sizeof(particle) * n, cudaMemcpyDeviceToHost);
    glEnable(GL_DEPTH_TEST);
    int l = 0;
    //game loop:
    while(!glfwWindowShouldClose(window))
    {
		GLfloat currentFrame = glfwGetTime();
		deltaTime = currentFrame - lastFrame;
		lastFrame = currentFrame;
		
       
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        //check and call events
        glfwPollEvents();
        do_movement();
        //rendering commands:
        glClearColor(0.1f, 0.1f, 0.1f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
        updateParticles<<<128,128>>>(a_dev);
        //if(l == 1) {
        cudaMemcpy(a, a_dev, sizeof(particle)*n,cudaMemcpyDeviceToHost); l=0;//}
        l++;
        cout <<a[0].x.x << " " << a[1].x.x << endl;
		//set up shader
        lightingShader.Use();
        GLint objectColorLoc = glGetUniformLocation(lightingShader.Program, "objectColor");
        GLint lightColorLoc = glGetUniformLocation(lightingShader.Program, "lightColor");
        GLint lightPosLoc = glGetUniformLocation(lightingShader.Program, "lightPos");
        glUniform3f(objectColorLoc, 160.0f/255.0f, 82.0f/255.0f, 45.0f/255.0f);
        glUniform3f(lightColorLoc, 1.0f, 1.0f, 1.0f);
        glUniform3f(lightPosLoc, 0.0f, 0.0f, 100.0f);
        
        
        glBindVertexArray(VAO);
        
        GLfloat timeValue = 0 * glfwGetTime();
        
        
        
        glm::mat4 view;
        view = camera.GetViewMatrix();
        
		
        glm::mat4 projection;
        projection = glm::perspective(camera.Zoom, (float)screenWidth / (float)screenHeight, 0.1f, 1000.0f);
        
        GLint modelLoc = glGetUniformLocation(lightingShader.Program, "model");
        GLint projLoc = glGetUniformLocation(lightingShader.Program, "projection");
        GLint viewLoc = glGetUniformLocation(lightingShader.Program, "view");
        
        
        
        glUniformMatrix4fv(projLoc, 1, GL_FALSE, glm::value_ptr(projection));
        glUniformMatrix4fv(viewLoc, 1, GL_FALSE, glm::value_ptr(view));

        //GLint colorOffset = glGetUniformLocation(ourShader.Program, "colorOffset");
        //glUniform3f(colorOffset, std::abs(sin(0.5 * timeValue)), std::abs(cos(0.7*timeValue + 0.5)), std::abs(sin(timeValue)));
        
	    for (int i = 0; i < n; i++) {
            glm::mat4 model;
            model = glm::translate(model, glm::vec3(a[i].x.x, a[i].x.y, a[i].x.z));
            model = glm::scale(model, glm::vec3(0.25f, 0.25f, 0.25f));
            glUniformMatrix4fv(modelLoc, 1, GL_FALSE, glm::value_ptr(model));
            glDrawArrays(GL_TRIANGLES, 0,(GLsizei)triangles.size() * (GLsizei)sizeof(triangles));
        }
        
        
		glBindVertexArray(0);
		
        glfwSwapBuffers(window);
        
    }
    
    cudaFree(a_dev);
	free(a);
    glDeleteVertexArrays(1, &VAO);
    glDeleteBuffers(1, &VBO);

    glfwTerminate();
    return 0;
}

void key_callback(GLFWwindow* window, int key, int scancode, int action, int mode)
{
    if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS)
        glfwSetWindowShouldClose(window, GL_TRUE);
    if (key >= 0 && key < 1024)
    {
        if (action == GLFW_PRESS)
            keys[key] = true;
        else if (action == GLFW_RELEASE)
            keys[key] = false;
    }
}

void do_movement()
{
    // Camera controls
    if (keys[GLFW_KEY_W])
        camera.ProcessKeyboard(FORWARD, deltaTime);
    if (keys[GLFW_KEY_S])
        camera.ProcessKeyboard(BACKWARD, deltaTime);
    if (keys[GLFW_KEY_A])
        camera.ProcessKeyboard(LEFT, deltaTime);
    if (keys[GLFW_KEY_D])
        camera.ProcessKeyboard(RIGHT, deltaTime);
}

bool firstMouse = true;
void mouse_callback(GLFWwindow* window, double xpos, double ypos)
{
    if (firstMouse)
    {
        lastX = xpos;
        lastY = ypos;
        firstMouse = false;
    }

    GLfloat xoffset = xpos - lastX;
    GLfloat yoffset = lastY - ypos;  // Reversed since y-coordinates go from bottom to left

    lastX = xpos;
    lastY = ypos;

    camera.ProcessMouseMovement(xoffset, yoffset);
}

void scroll_callback(GLFWwindow* window, double xoffset, double yoffset)
{
    camera.ProcessMouseScroll(yoffset);
}
	
