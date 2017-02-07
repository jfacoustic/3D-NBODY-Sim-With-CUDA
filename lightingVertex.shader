#version 330 core
layout (location = 0) in vec3 position;
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;
out vec3 Normal;
out vec3 FragPos;
void main() {
	Normal = position;
	FragPos = vec3(model * vec4(position, 1.0f));
	gl_Position = projection * view * model * vec4(position, 1.0f);
}
