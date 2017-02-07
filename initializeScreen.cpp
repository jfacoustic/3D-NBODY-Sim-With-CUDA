#include "initializeScreen.hpp"

int initilizeScreen(GLFWwindow *& window, int screenWidth, int screenHeight) {
	glfwInit(); // first intialize GLFW with glfwInit
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3); //Version 3 OPENGL
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3); //Version 3.3 OPENGL
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE); //Specifically using CORE profile; can't use legacy
    glfwWindowHint(GLFW_RESIZABLE, GL_FALSE); //window not resizable
    window = glfwCreateWindow(screenWidth, screenHeight, "LearnOpenGL", nullptr, nullptr);
    if (window == nullptr)
    {
        std::cout << "Failed to create GLFW window" << std:: endl;
        glfwTerminate();
        return -1;
    }
    
    glfwMakeContextCurrent(window);
    return 0;
}
