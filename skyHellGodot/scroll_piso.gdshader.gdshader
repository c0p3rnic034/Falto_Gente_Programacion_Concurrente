shader_type canvas_item;

uniform float offset_y = 0.0;

void fragment() {
    vec2 uv = UV;
    uv.y -= offset_y;
    COLOR = texture(TEXTURE, uv);
}