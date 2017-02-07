#version 330 core

layout (location = 0) in vec3 position;
layout (location = 1) in vec3 color;

uniform vec4 offset;
uniform vec3 colorOffset;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

out vec3 ourColor;
out vec4 ourPosition;
void main()
{
    gl_Position = projection * view * model * vec4(position, 1.0f);
    ourPosition = gl_Position;
    ourColor = color;
}
