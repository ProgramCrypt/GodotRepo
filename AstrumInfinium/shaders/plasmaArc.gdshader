shader_type spatial;
render_mode blend_mix;

varying vec3 pos;
varying vec3 dir;

uniform vec4 color1 : source_color = vec4(0.39, 0.0, 1.0, 1.0);
uniform vec4 color2 : source_color = vec4(1.0, 0.0, 0.27, 1.0);
uniform float emissionMultiplier: hint_range(0.0, 50.0) = 1.0;
uniform float fresnelAmount : hint_range(0.0, 40.0, 0.1) = 1.0;

uniform vec3 origin = vec3(0.0, 0.0, 0.0);
uniform vec3 contactPoint = vec3(0.58, 0.58, 0.58);

vec3 matrixMult(mat4 matrix, vec3 vector) 
{
	return (matrix * vec4(vector, 0.0)).xyz;
}

float fresnel(float power, vec3 normal, vec3 view) // vec3 meshDir,
{
	return pow(abs(dot(normalize(normal), normalize(view))), power); // / max(abs(length(cross(normalize(meshDir), normalize(view)))), 0.001)
}

void vertex() {
	float len = length(contactPoint - origin);
	pos = (VERTEX - origin) / len;
}

void fragment() {
	dir = normalize(origin - contactPoint);
	dir = matrixMult(MODEL_MATRIX, dir);
	dir = matrixMult(VIEW_MATRIX, dir);
	vec3 viewProj = normalize(VIEW - dir * dot(VIEW, dir));
	float fresnel = fresnel(fresnelAmount, NORMAL, viewProj);
	float smoothFresnel = smoothstep(0.0, 1.0, fresnel);
	float gradientPos = length(pos);
	ALBEDO.rgb = vec3(0.0);
	EMISSION = mix(color1.rgb, color2.rgb, gradientPos) * emissionMultiplier * (fresnel + 1.0);
	ALPHA = fresnel;
}