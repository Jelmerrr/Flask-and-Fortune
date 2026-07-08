shader_type canvas_item;

uniform bool enableWind = true;
uniform bool enableOutline = true;

group_uniforms Wind_Shader;
uniform bool render_noise = false;
uniform float framerate = 7.0; // Framerate for worldspace and viewspace grass rotation
uniform bool quantised = true; // Toggle quantised framerate
uniform sampler2D noise_texture : repeat_enable; // set in inspector
uniform float amplitude : hint_range(0.0, 0.5, 0.01) = 0.04;
uniform float time_scale : hint_range(0.0, 5.0, 0.01) = 0.04;
uniform float noise_scale : hint_range(0.0, 2.0, 0.0001) = 0.001;
uniform float rotation_strength : hint_range(0.0, 5.0, 0.1) = 1;
uniform vec2 rotation_pivot = vec2(0.5, 1);
varying float time;
varying vec2 world_position;
varying vec3 object_origin;

group_uniforms Outline_Shader;
uniform vec4 outline_color : source_color = vec4(1.0);
uniform float strength: hint_range(0.0, 1.0) = 0;

float location_seed (vec2 location) { // Random value based on world space location
	return fract(sin(dot(location, vec2(12.9898,78.233))) * 43758.5453123);
}

void vertex(){
    world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;

	// Find origin of each quad of grass in world-space
	object_origin = (MODEL_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xyz;

	// Generate a random seed based on the objects world position
	float seed = 10.0 * location_seed(object_origin.xy);
	// Calculate time between frames
	float frametime = 1.0 / framerate;
	// Calculate randomised phase of framerate for each quad based on the world position
	// This so they don't all update on the same frame as that would just look laggy
	float phase = mod(seed, frametime);

	time = TIME;
	if (quantised) {
		// Offset framerate update based on objects unique phase
		time += phase;
		// Quantise the time to create a stepped framerate
		time = round(time * framerate) / framerate;
	}
}

vec2 get_sample_pos(vec2 pos, float scale, float offset) {
	pos *= scale;
	pos += offset;
	return pos;
}

vec2 rotate_vec(vec2 vec, vec2 pivot, float rotation) {
	float cosa = cos(rotation);
	float sina = sin(rotation);
	vec -= pivot;
	return vec2(
		cosa * vec.x - sina * vec.y,
		cosa * vec.y + sina * vec.x
	) + pivot;
}

void fragment() {
	// get noise from texture
	vec2 noise_sample_pos = get_sample_pos(world_position, noise_scale, time * time_scale);
	float noise_amount = texture(noise_texture, noise_sample_pos).r - 0.5f;

	// get rotation position around a pivot
	float rotation = amplitude * noise_amount;
	vec2 rotated_uvs = rotate_vec(UV, rotation_pivot, rotation);

	// blend original uvs and rotated uvs based on distance to pivot
	float dist = distance(UV, rotation_pivot) * rotation_strength;
	vec2 result_uvs = mix(UV, rotated_uvs, dist);

	// output color
	COLOR = texture(TEXTURE, result_uvs);

	// optional, preview noise texture for debugging
	if (render_noise) {
		vec4 noise_color = texture(noise_texture, noise_sample_pos);
		COLOR = noise_color;
	}

	vec4 updatedTexture = texture(TEXTURE, result_uvs);

	//Outline shader
	float size_x = 1.0/float(textureSize(TEXTURE, 0).x);
	float size_y = 1.0/float(textureSize(TEXTURE, 0).y);
	vec4 sprite_color = COLOR; //texture(TEXTURE, UV);
	float alpha = -4.0 * sprite_color.a;
	alpha += texture(TEXTURE, result_uvs + vec2(size_x, 0)).a * strength;
	alpha += texture(TEXTURE, result_uvs + vec2(-size_x, 0)).a * strength;
	alpha += texture(TEXTURE, result_uvs + vec2(0, size_y)).a * strength;
	alpha += texture(TEXTURE, result_uvs + vec2(0, -size_y)).a * strength;
	vec4 final_color = mix(sprite_color, outline_color, clamp(alpha * strength, 0.0, 1.0));
	COLOR = vec4(final_color.rgb, clamp(abs(alpha) + sprite_color.a, 0.0, 1.0));
}