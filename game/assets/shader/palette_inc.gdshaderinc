//uniform sampler2D original_palettes;
//uniform sampler2D new_palettes;
//uniform int colors_counts;



vec4 sawp(sampler2D original_palettes, sampler2D new_palettes, int colors_counts, vec4 color_or) {
	//vec4 n_out3p0;
// Texture2D:3
	//n_out3p0 = texture(TEXTURE, UV);


// IntParameter:6
	int n_out6p0 = colors_counts;


	vec2 new_uv = vec2(0, 0);
	float dist;
	
	for (int i = 0; i < n_out6p0; i++) {
		float u = (float(i) + 0.5) / float(n_out6p0);
		float v = 0.5;
		vec2 uv = vec2(u, v);
		vec4 original_palette_color = texture(original_palettes, uv);
		dist = distance(color_or, original_palette_color);
		
		if (dist == 0.0) {
			new_uv = uv;
			break;
		}
	}
		
	if (dist == 0.0) {
		return (texture(new_palettes, new_uv));
	}
	else {
		return(color_or);
	}
}
