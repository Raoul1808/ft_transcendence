//shader_type canvas_item;
//render_mode blend_mix;

//uniform sampler2D original_palettes;
//uniform sampler2D new_palettes;
//uniform int colors_counts;
//uniform sampler2D high_map;
//uniform vec4 side;
//uniform vec2 size;
//uniform vec3 rotate;



vec3 normal_map(float hight, vec2 normal_UV) {

	//vec3 ret ;
	
	//return (vec3(normal_UV.x, 1.0 - normal_UV.y, 0.5 + hight / 2.0));
	return (vec3(0.5 + hight / 2.0, 0.5 + hight / 2.0, 0.5 + hight / 2.0));
}
