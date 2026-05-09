void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec2 texel = 1.0 / iResolution.xy;

    vec4 data = texture(iChannel0, uv);
    float h_last = data.r; 
    float h_prev = data.g; 
    float h_up    = texture(iChannel0, uv + vec2(0, texel.y)).r;
    float h_down  = texture(iChannel0, uv - vec2(0, texel.y)).r;
    float h_left  = texture(iChannel0, uv - vec2(texel.x, 0)).r;
    float h_right = texture(iChannel0, uv + vec2(texel.x, 0)).r;

    float h_now = (h_up + h_down + h_left + h_right) * 0.5 - h_prev;
    h_now *= 0.999;

    if (iMouse.z > 0.0) {
        float d = length(fragCoord.xy - iMouse.xy);
        if (d < 10.0) 
        {
            h_now = 1.0; 
        }
    }
    fragColor += vec4(h_now, h_last, 0.0, 1.0);
}

