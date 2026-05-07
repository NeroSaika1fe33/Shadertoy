
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec2 texel = 1.0 / iResolution.xy;

    // 1. 获取高度
    float h = texture(iChannel0, uv).r;

    // 2. 利用你之前的差分法求法线 (把 getWaveHeight 换成采样)
    float e = texel.x;
    float hx = texture(iChannel0, uv + vec2(e, 0.0)).r - h;
    float hy = texture(iChannel0, uv + vec2(0.0, e)).r - h;
    
    vec3 n = normalize(vec3(-hx, -hy, 0.1)); // 这里的 0.1 决定了波纹看起来有多硬

    // 3. 渲染
    vec3 col = mix(vec3(0.1, 0.2, 0.5), vec3(0.8, 0.9, 1.0), n.z);
    
    // 增加一点反射感
    float spec = pow(max(0.0, n.z), 10.0);
    fragColor = vec4(col + spec, 1.0);
}