shader_type spatial;
render_mode unshaded, blend_mix, cull_disabled, depth_draw_never;

uniform sampler2D fog_texture : filter_linear, repeat_disable;
uniform vec4 fog_color_unexplored : source_color = vec4(0.02, 0.03, 0.04, 0.96);
uniform vec4 fog_color_explored : source_color = vec4(0.05, 0.07, 0.10, 0.62);

void fragment() {
	vec4 fog_sample = texture(fog_texture, UV);
	float live_vis = fog_sample.r;
	float explored = fog_sample.g;
	
	if (live_vis >= 0.95) {
		// Fully visible live area
		ALBEDO = vec3(0.0);
		ALPHA = 0.0;
	} else if (live_vis > 0.05) {
		// Soft edge transition between visible and explored/unexplored
		vec4 base_fog = mix(fog_color_unexplored, fog_color_explored, explored);
		ALBEDO = base_fog.rgb;
		ALPHA = base_fog.a * (1.0 - live_vis);
	} else {
		// Outside live vision
		if (explored > 0.1) {
			// Explored Grey Fog of War (Dota 2 Memory State)
			ALBEDO = fog_color_explored.rgb;
			ALPHA = fog_color_explored.a * explored;
		} else {
			// Unexplored Pitch Black Fog
			ALBEDO = fog_color_unexplored.rgb;
			ALPHA = fog_color_unexplored.a;
		}
	}
}
