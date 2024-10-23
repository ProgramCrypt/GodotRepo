shader_type spatial;

uniform vec4 color : source_color = vec4(0.55, 0.0, 1.0, 1.0);
uniform float emissionMultiplier: hint_range(1.0, 50.0) = 1.0;
uniform float fresnelAmount : hint_range(0.0, 8.0, 0.1) = 1.0;

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

void fragment() {
	ALBEDO = color.rgb;
	EMISSION = ALBEDO * emissionMultiplier;
	ALPHA = fresnel(fresnelAmount, NORMAL, VIEW);
}