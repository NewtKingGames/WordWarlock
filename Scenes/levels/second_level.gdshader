shader_type canvas_item;
render_mode blend_add, unshaded;
// 2D light shader by HaruYou27.

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;

uniform float intensity = 10.0;

void fragment() {
    // Sample the underlying screen color
    vec3 under_color = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;

    // Make it brighter
    vec3 final_color = under_color * COLOR.rgb * intensity;

    // Don't forget the alpha value
    COLOR = vec4(final_color, COLOR.a);
}