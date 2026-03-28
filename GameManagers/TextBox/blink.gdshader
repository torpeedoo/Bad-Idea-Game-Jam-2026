shader_type canvas_item;

uniform float speed = 2.0; // lower = slower blink
uniform float min_alpha = 0.2; // how dim it gets (0 = fully invisible)

void fragment() {
	float wave = (sin(TIME * speed) + 1.0) * 0.5; // 0 → 1
	float alpha = mix(min_alpha, 1.0, wave); // smooth fade
	
	COLOR.a *= alpha;
}