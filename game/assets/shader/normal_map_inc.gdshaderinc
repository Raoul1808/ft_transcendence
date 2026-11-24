//shader_type canvas_item;
//render_mode blend_mix;

//uniform sampler2D original_palettes;
//uniform sampler2D new_palettes;
//uniform int colors_counts;
//uniform sampler2D high_map;
//uniform vec4 side;
//uniform vec2 size;
//uniform vec3 rotate;



vec3 normal_map(sampler2D original_palettes, sampler2D high_map, int colors_counts, vec4 color_or, vec2 normal_UV, vec4 side, vec2 size, vec3 rotate) {


// Reroute:15
	//vec4 color_or = texture(TEXTURE, normal_UV);

	//vec4 n_out7p0;
	//n_out7p0 = vec4(0.0, 0.0, 0.0, 0.0);
	//{
		//vec2 new_uv = vec2(0, 0);
		//float dist;
		//
		//for (int i = 0; i < colors_counts; i++) {
			//float u = (float(i) + 0.5) / float(colors_counts);
			//float v = 0.5;
			//vec2 uv = vec2(u, v);
			//vec4 original_palette_color = texture(original_palettes, uv);
			//dist = distance(color_or, original_palette_color);
			//
			//if (dist == 0.0) {
				//new_uv = uv;
				//break;
			//}
		//}
		//
		//if (dist == 0.0) {
			//n_out7p0 = texture(new_palettes, new_uv);
		//}
		//else {
			//n_out7p0 = color_or;
		//}
		//
		//;
	//}


	vec4 ret;
// Expression:8
	ret = vec4(0.0, 0.0, 0.0, 0.0);
	{
		vec2 new_uv = vec2(0, 0);
		float dist;
		
		for (int i = 0; i < colors_counts; i++) {
			float u = (float(i) + 0.5) / float(colors_counts);
			float v = 0.5;
			vec2 uv = vec2(u, v);
			vec4 original_palette_color = texture(original_palettes, uv);
			dist = distance(color_or, original_palette_color);
			
			if (dist == 0.0) {
				new_uv = uv;
				break;
			}
		}
		vec2 new_uv2 = vec2(0, 0);
		new_uv2[0] = float(int((normal_UV.x * size.x)) % 32) / 32.0;
		new_uv2[1] = float(int((normal_UV.y * size.y)) % 32) / 32.0;
		if (rotate[0] == 1.0) {
			float tmp = new_uv2[0];
			new_uv2[0] = new_uv2[1];
			new_uv2[1] = tmp;
		}
		if (dist == 0.0) {
			if (side[0] == 1.0) {
				if (new_uv2[0] <= 0.5) {
					new_uv2[0] = 0.5 * (1.0 - new_uv2[0]) + new_uv2[0] * (new_uv2[0]);
				}
			}
			if (side[1] == 1.0) {
				if (new_uv2[1] <= 0.5) {
					new_uv2[1] = 0.5 * (1.0 - new_uv2[1]) + new_uv2[1] * (new_uv2[1]);
				}
			}
			if (side[2] == 1.0) {
				if (new_uv2[0] >= 0.5) {
					new_uv2[0] = 0.5 * (new_uv2[0]) + new_uv2[0] * (1.0 - new_uv2[0]);
				}
			}
			if (side[3] == 1.0) {
				if (new_uv2[1] >= 0.5) {
					new_uv2[1] = 0.5 * (new_uv2[1]) + new_uv2[1] * (1.0 - new_uv2[1]);
				}
			}
			if (rotate[1] == 1.0) {
				new_uv2[0] = -new_uv2[0];
			}
			if (rotate[2] == 1.0) {
				new_uv2[1] = -new_uv2[1];
			}
			ret = vec4(new_uv2[0] + rotate[1], 1.0 - new_uv2[1] - rotate[2], 0.5 + 1.0 * texture(high_map, new_uv)[0] / 2.0, 1.0);
		}
		else {
			ret = color_or;
		}
		;
	}



// Output:0
	//COLOR.rgb = vec3(n_out7p0.xyz);
	//NORMAL_MAP = vec3(n_out23p0.xyz);

	return (vec3(ret.xyz));
}
