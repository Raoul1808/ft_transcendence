shader_type canvas_item;
#include "palette_inc.gdshaderinc"
#include "normal_map_inc.gdshaderinc"
uniform sampler2D original_palettes;
uniform sampler2D new_palettes;
uniform int colors_counts;
uniform sampler2D high_map;
uniform vec4 side;
uniform vec2 size;
uniform vec3 rotate;

void vertex() {
	// Called for every vertex the material is visible on.
	float T = -1.0;
	float TT = 1.0;
	float TO = 0.0;
	int seed = int((UV.y * 192.0) / 32.0) + int((UV.x * 128.0) / 32.0);
	float mv = cos(cos(TIME) * T + sin(TIME) * TO + float(seed));
	float balence = cos(TIME + cos(TIME) + mv);
	VERTEX.x += mv * ((32.0 - float(int(UV.y * 192.0) % 32)) / 8.0);
	VERTEX.y += mv * ((32.0 - float(int(UV.x * 128.0) % 32)) / 16.0);
}

void fragment() {
	// Called for every pixel the material is visible on.
	//COLOR = vec4(normal_map(original_palettes, high_map, colors_counts, COLOR, UV, side, size, rotate), COLOR[3]);
	COLOR = swap(original_palettes, new_palettes, colors_counts, COLOR);
	NORMAL_MAP = normal_map(original_palettes, high_map, colors_counts, COLOR, UV, side, size, rotate);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
