shader_type spatial;
render_mode unshaded,shadows_disabled,cull_disabled;

uniform sampler2D portal : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//if (!SMOOTHER_PORTAL_TRANSITIONS){ALPHA_HASH_SCALE = 0.01;}
	ALPHA = COLOR.x;
	ALBEDO = texture(portal,SCREEN_UV).rgb;
}
