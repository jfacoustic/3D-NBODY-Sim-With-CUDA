#ifndef SHADER_H
#define SHADER_H

#include <string>
#include <fstream>
#include <sstream>
#include <iostream>

#include <GL/glew.h>

class Shader
{
public:
    //program ID:
    GLuint Program;
    //Constructor reads/builds shader:
    Shader(const GLchar *vertexPath, const GLchar *fragmentPath);
    
    void Use();
    
};

#endif

