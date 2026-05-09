void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec2 texel = 2.0 / iResolution.xy;

    float h = texture(iChannel0, uv).r;

    float e = texel.x;
    float hx = texture(iChannel0, uv + vec2(e, 0.0)).r - h;
    float hy = texture(iChannel0, uv + vec2(0.0, e)).r - h;
    
    vec3 n = normalize(vec3(-hx, -hy, 50)); 

    vec3 col = mix(vec3(0.1, 0.2, 0.5), vec3(0.8, 0.0, 0.5), n.z);
    
    float spec = pow(max(0.0, n.z), 1.0);
    fragColor = vec4(col + spec, 1.0);
}