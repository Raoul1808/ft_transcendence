shader_type canvas_item;
#include "palette_inc.gdshaderinc"
uniform sampler2D original_palettes;
uniform sampler2D new_palettes;
uniform int colors_counts;
uniform float health;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	if (health / 100.0 < UV.x)
		COLOR = swap(original_palettes, new_palettes, colors_counts, COLOR);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
