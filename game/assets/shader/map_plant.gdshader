shader_type canvas_item;

void vertex() {
		VERTEX.x += cos(TIME) * ((32.0 - float(int(UV.y * 128.0) % 32)) / 4.0);
		
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
