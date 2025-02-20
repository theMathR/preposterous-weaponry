shader_type canvas_item;

uniform float activity = 1.;

void fragment() {
	if (COLOR.b > COLOR.r) {

		COLOR = mix(
			COLOR,
			mix(
				vec4(0.5,1.,1.,1.),
				vec4(1.,1.,1.,1.),
				0.5+sin(POINT_COORD.x*-10.+TIME*activity*16.)/2.
			)
			, min(1., activity*2.)
		);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
