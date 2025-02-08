shader_type canvas_item;

uniform sampler2D image;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (COLOR.r == COLOR.g && COLOR.r == COLOR.b && COLOR.r < 0.9 && COLOR.r > 0.) {

		COLOR = texture(image, SCREEN_UV);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
