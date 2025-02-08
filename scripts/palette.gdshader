shader_type canvas_item;

uniform vec4 grayscale_color : source_color = vec4(1,1,1,1);
uniform float green_scale = 1.;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (COLOR.r == COLOR.g && COLOR.r == COLOR.b && COLOR.r < 0.9) {
		float a = COLOR.a;
		COLOR = grayscale_color * COLOR.r;
		COLOR.a = a;
	}
	else if (COLOR.r == 0. && COLOR.g > COLOR.b) {
		float a = COLOR.a;
		COLOR *= green_scale;
		COLOR.a = a;
	}
}
