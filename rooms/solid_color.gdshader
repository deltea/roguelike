shader_type canvas_item;

uniform vec3 new_color : source_color;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (color.a == 0.0) COLOR = vec4(0.0);
	else COLOR = vec4(new_color, 1.0);
}