shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
	
}

void fragment() {
	// Called for every pixel the material is visible on.
	float blue = 1.0; // you can assign a default value to uniforms
	COLOR = texture(TEXTURE, UV); // Read from texture
	COLOR.g = SCREEN_UV.x + SCREEN_UV.y;
	//VERTEX.x;
	//COLOR.x = 1.0;
	
	SCREEN_UV.x;
	SCREEN_UV.y;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
