shader_type canvas_item;

uniform vec4 color : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (COLOR.r == COLOR.g && COLOR.r == COLOR.b && COLOR.r < 0.9) {
		float a = COLOR.a;
		COLOR = color * COLOR.r;
		COLOR.a = a;
	}
}
