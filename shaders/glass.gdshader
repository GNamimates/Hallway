shader_type spatial;

uniform sampler2D SCREEN : hint_screen_texture,repeat_disable;
uniform float refraction : hint_range(0.0, 0.5, 0.001);
uniform float chromatic_aberration : hint_range(0.0, 0.5, 0.001);

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float r = -refraction;
	float f = fresnel(10.0,NORMAL,VIEW);
	vec3 n = NORMAL*(1.0-fresnel(1.0,NORMAL,VIEW));
	vec3 clr = vec3(
		texture(SCREEN,SCREEN_UV+n.xy*r).r,
		texture(SCREEN,SCREEN_UV+n.xy*r*(2.0*chromatic_aberration + 1.0)).g,
		texture(SCREEN,SCREEN_UV+n.xy*r*(3.0*chromatic_aberration + 1.0)).b
	);
	ALBEDO = mix(clr,vec3(1),f);
}

void light() {
	float f = fresnel(10.0,NORMAL,VIEW);
	DIFFUSE_LIGHT += mix(vec3(0.22),clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION * LIGHT_COLOR,f);
}
