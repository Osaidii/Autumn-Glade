shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 0.8, 0.2, 1.0);
uniform float intensity = 2.0;

void fragment() {
    COLOR = texture(TEXTURE, UV);
    // Add glow emission
    COLOR.rgb += glow_color.rgb * intensity;
}