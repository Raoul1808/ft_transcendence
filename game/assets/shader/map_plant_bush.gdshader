shader_type canvas_item;

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
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
