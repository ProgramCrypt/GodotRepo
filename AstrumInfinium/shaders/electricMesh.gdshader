// NOTE: Shader automatically converted from Godot Engine 4.2.2.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : source_color = vec4(0.0, 1.0, 0.0, 1.0);
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;
uniform float point_size : hint_range(0,128) = 1.0;
uniform float roughness : hint_range(0,1) = 1.0;
uniform float emission : hint_range(0, 5) = 1.0;
uniform sampler2D texture_metallic : hint_default_white,filter_linear_mipmap,repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r,filter_linear_mipmap,repeat_enable;
uniform float specular : hint_range(0,1) = 0.5;
uniform float metallic : hint_range(0,1) = 0.2;
uniform sampler2D texture_normal : hint_roughness_normal,filter_linear_mipmap,repeat_enable;
uniform float normal_scale : hint_range(-16,16) = 4.0;
uniform sampler2D texture_heightmap : hint_default_black,filter_linear_mipmap,repeat_enable;
uniform float heightmap_scale;
uniform int heightmap_min_layers;
uniform int heightmap_max_layers;
uniform vec2 heightmap_flip;
uniform vec3 uv1_scale = vec3(1, 1, 1);
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;


vec2 random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * TIME * 0.13);
}

float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix( mix( dot( random(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
                     dot( random(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), blur.x),
                mix( dot( random(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
                     dot( random(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), blur.x), blur.y) + 0.5;
}

void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
}

void fragment() {
	vec2 base_uv = UV;
	{
		//base_uv.y += sin((TIME * 1.4) + (base_uv.x * 25.0)) * 0.03;
		//base_uv.x += sin((TIME * 1.0) + (base_uv.y * 25.0)) * 0.03;
		base_uv.x += noise(base_uv * 16.0) * 0.41 * sin(TIME * 0.53 * (base_uv.y / (431.0)));
		base_uv.y += noise(base_uv * 16.0) * 0.37 * cos(TIME * 0.79 * (base_uv.x / (691.0)));
		vec3 view_dir = normalize(normalize(-VERTEX + EYE_OFFSET) * mat3(TANGENT * heightmap_flip.x, -BINORMAL * heightmap_flip.y, NORMAL));
		float depth = 1.0 - texture(texture_heightmap, base_uv).r;
		vec2 ofs = base_uv - view_dir.xy * depth * heightmap_scale * 0.01;
		base_uv=ofs;
	}
	
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	float red = pow(albedo.r * albedo_tex.r * 2.0, 2.0) / 4.0;
	float green = pow(albedo.g * albedo_tex.g * 2.0, 2.0) / 4.0;
	float blue = pow(albedo.b * albedo_tex.b * 2.0, 2.0) / 4.0;
	float noise = noise(base_uv * 16.0);
	ALBEDO = vec3(red, green, blue); //albedo.rgb * albedo_tex.rgb
	EMISSION = vec3(red, green, blue) * emission * noise; //
	float metallic_tex = dot(texture(texture_metallic,base_uv),metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	vec4 roughness_texture_channel = vec4(1.0,0.0,0.0,0.0);
	float roughness_tex = dot(texture(texture_roughness,base_uv),roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
	SPECULAR = specular;
	NORMAL_MAP = texture(texture_normal,base_uv).rgb;
	NORMAL_MAP_DEPTH = normal_scale;
}
