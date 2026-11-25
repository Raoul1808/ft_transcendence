shader_type canvas_item;
uniform sampler2D high_map;
#include "../normalmap_water_inc.gdshaderinc"

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 pos = UV;
	float nu = pos.x;
	//nu = 0.0;
	//pos.x *= cos(TIME);
	
	//if (pos.y <= 0.5) {
		//pos.y += 0.5;
	//} else {
		//
		//pos.y = 1.5 - pos.y;
	//}
	
	if (pos.x <= (cos(TIME) * 0.5 + 0.5)) {
		//pos.x += (cos(TIME) * 0.5 + 0.5);
	} else {
		
		//pos.x = 1.0 - pos.x;
		//pos.x -= (cos(TIME) * 0.5 + 0.5);
	}
	
	float t = (TIME / 10.0) * 2.0 - floor((TIME / 10.0) * 2.0);
	float u = 0.0;
	float t2 = (TIME / 10.0) * 2.0 + 0.5 - floor((TIME / 10.0) * 2.0 + 0.5);
	float u2 = 0.0;
	//t *= 1.0;
	//t = 1.0;
	//t2 = 0.5;
	COLOR.r = 0.0;
	COLOR.g = 0.0;
	COLOR.b = 0.0;
	
	if (UV.x <= t + 0.1 && UV.x >= t - 0.1) {
		//COLOR.g = 1.0;
		//COLOR = vec4(0,0,0,1);
	}
	if (UV.x <= t2 + 0.1 && UV.x >= t2 - 0.1) {
		//COLOR.r = 1.0; //c'est lavant
	}
	if (t >= t2) {
		u = 1.0;
		
	}
	else {
		u = t2;
	}
	if (t2 <= t) {
		u2 = 0.0;
	}
	else {
		u2 = t;
	}
	nu = 0.0;
	if (t == u2 && UV.x >= t && UV.x <= t2) {
		//COLOR.g = 1.0;
		float tmp;
		tmp = t + 0.25;
		//pos.x *= tmp;
		if (pos.x <= tmp) {
			//pos.x *= 0.5 / tmp;
			pos.x = 1.0 - pos.x;
			pos.x *= (1.0 - (tmp));
			//COLOR.g = 1.0;
		}
		else {
			pos.x *= (tmp);
			//pos.x = 1.0 - pos.x;
			//pos.x *= 0.5 / (1.0 - (tmp));
			//COLOR.r = 1.0;
		}
		nu = pos.x;
	}
	else {
		if (UV.x >= t && UV.x <= u) {
			//COLOR.b = 1.0;
			float tmp;
			tmp = t + 0.25;
			if (UV.x <= tmp) {
				
				pos.x = 1.0 - pos.x;
				pos.x *= 0.5 / (1.25 - (tmp));
				//COLOR.g = 1.0;
				
				
			}
			else {
				//pos.xpos *= 0.5 / (tmp);
				//COLOR.r = 1.0;
				
			}
			nu = pos.x;
		}
		if (UV.x >= u2 && UV.x <= t2) {
			//COLOR.r = 1.0;
			float tmp;
			tmp = t2 - 0.25;
			//if (UV.x <= tmp) {
				//pos.x *= 0.5 / tmp;
				////COLOR.g = 1.0;
			//}
			//else {
				//pos.x = 1.0 - pos.x;
				//pos.x *= 0.5 / (1.0 - (tmp));
				////COLOR.r = 1.0;
			//}
			//nu = pos.x;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//if (pos.x <= t + 0.5 && pos.x >= t - 0.5) {
		////pos.x += (cos(TIME) * 0.5 + 0.5);
		////pos.x = 1.0 - pos.x;
		////if (UV.x == t)
		//if (pos.x <= t) {
			//pos.x *= 0.5 / t;
		//}
		//else {
			//pos.x = 1.0 - pos.x;
			//pos.x *= 0.5 / (1.0 - (t));
		//}
	//} else {
	//
		////pos.x = 0.0;
		////pos.x -= (cos(TIME) * 0.5 + 0.5);
	//}
	//if (pos.x <= t2 + 0.5 && pos.x >= t2 - 0.5) {
		////pos.x += (cos(TIME) * 0.5 + 0.5);
		////pos.x = 1.0 - pos.x;
		////pos.x *= 0.5 / (1.0 - (t2));
		////pos.x *= 0.5 / t2;
		//if (pos.x <= t2) {
			//pos.x *= 0.5 / t2;
		//}
		//else {
			//pos.x = 1.0 - pos.x;
			//pos.x *= 0.5 / (1.0 - (t2));
		//}
	//} else {
		////pos.x = 0.0;
		////pos.x = 1.0 - pos.x;
		////pos.x *= 0.5 / (1.0 - (t2));
		////pos.x *= 0.5 / t2;
		////pos.x -= (cos(TIME) * 0.5 + 0.5);
	//}
	//if (pos.x <= 0.5) {
		//if (pos.x <= t) {
			////pos.x += (cos(TIME) * 0.5 + 0.5);
			////pos.x = 1.0 - pos.x;
			//pos.x *= 0.5 / t;
		//} else {
		//
			//pos.x = 0.5 - pos.x;
			//pos.x *= 0.5 / (0.5 - (t));
			////pos.x -= (cos(TIME) * 0.5 + 0.5);
		//}
		//if (pos.x <= t2) {
			////pos.x += (cos(TIME) * 0.5 + 0.5);
			////pos.x = 1.0 - pos.x;
			//pos.x *= 0.5 / t2;
		//} else {
		//
			//pos.x = 0.5 - pos.x;
			//pos.x *= 0.5 / (0.5 - (t2));
			////pos.x -= (cos(TIME) * 0.5 + 0.5);
		//}
		//
	//}
	//else {
		////if (pos.x <= t) {
			//////pos.x += (cos(TIME) * 0.5 + 0.5);
			//////pos.x = 1.0 - pos.x;
			////pos.x *= 0.5 / t;
		////} else {
		////
			////pos.x = 1.0 - pos.x;
			////pos.x *= 0.5 / (1.0 - (t));
			//////pos.x -= (cos(TIME) * 0.5 + 0.5);
		////}
	//}
	
	//if (pos.x <= 0.5) {
		//pos.x *= 2.0;
	//} else {
		//
		//pos.x = 1.0 - pos.x;
		//pos.x *= 2.0;
	//}
	//if (pos.x <= 0.25) {
		//pos.x *= 4.0;
	//} else {
		//
		//pos.x = 1.0 - pos.x;
		//pos.x *= 1.3333333333333333333;
	//}
	//pos.x -= (cos(TIME) * 0.5 + 0.5);
	//float t= (cos(TIME) * 0.5 + 0.5);
	//pos.x -= t * t * -4.0 + 4.0 * t;
	
	//NORMAL_MAP = normal_map(nu, SCREEN_UV);
	//NORMAL_MAP = normal_map(texture(high_map, vec2(UV.x + (cos(TIME) * 0.5 + 0.5), UV.y))[0], SCREEN_UV);
	//COLOR = vec4(normal_map(nu, SCREEN_UV), 1.0);
	COLOR = vec4(nu,nu,nu, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
