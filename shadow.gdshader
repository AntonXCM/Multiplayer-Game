shader_type canvas_item;

void fragment() {
	vec4 color = texture(TEXTURE,UV);
	COLOR = vec4(0,0,0, 0.3*color.a);
}
