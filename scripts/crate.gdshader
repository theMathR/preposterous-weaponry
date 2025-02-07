shader_type canvas_item;

uniform vec4 color : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (COLOR.g == 1.) {
		COLOR = mix(vec4(1.,1.,1.,1.), color, (cos(TIME) + 1.)/2.);
	}
}
