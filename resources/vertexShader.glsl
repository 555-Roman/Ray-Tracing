#version 330 core

layout(location = 0) in vec3 vPos;
layout(location = 1) in vec2 vWindowPos;

out vec2 windowPos;

void main() {
	gl_Position = vec4(vPos, 1.0);
	windowPos = vWindowPos;
}