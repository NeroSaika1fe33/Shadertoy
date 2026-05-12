void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec2 texel = 1.0 / iResolution.xy;

    // 1. 获取物理数据
    vec4 data = texture(iChannel0, uv);
    float h = data.r;
    vec2 vel = data.gb;

    // 2. 计算实时法线
    float hL = texture(iChannel0, uv - vec2(texel.x, 0)).r;
    float hR = texture(iChannel0, uv + vec2(texel.x, 0)).r;
    float hD = texture(iChannel0, uv - vec2(0, texel.y)).r;
    float hU = texture(iChannel0, uv + vec2(0, texel.y)).r;
    vec3 n = normalize(vec3(hL - hR, hD - hU, 0.15));

    // 3. 水面颜色
    // 高度为正：浅蓝；高度为负（由于吸收）：深蓝
    vec3 col = mix(vec3(0.05, 0.1, 0.2), vec3(0.4, 0.7, 1.0), h * 0.5 + 0.5);
    
    // 流速光效 (Speed)
    col += length(vel) * vec3(0.2, 0.4, 0.5);
    
    // 高光
    float spec = pow(max(0.0, n.z), 35.0);
    col += spec * 0.5;

    // 4. 渲染深灰色障碍物
    vec2 obsPos = iResolution.xy * 0.45;
    float dObs = length(fragCoord - obsPos) - 60.0;
    if (dObs < 0.0) {
        col = vec3(0.15); // 深灰色
    }
    // 障碍物描边增加质感
    col = mix(col, vec3(0.0), smoothstep(2.0, 0.0, abs(dObs)));

    // 5. 渲染排水口标识 (虚幻的深色洞口)
    vec2 drainPos = iResolution.xy * vec2(0.8, 0.2);
    float dDrain = length(fragCoord - drainPos);
    if (dDrain < 40.0) {
        float f = smoothstep(40.0, 10.0, dDrain);
        col = mix(col, vec3(0.0, 0.02, 0.05), f * 0.8);
    }

    fragColor = vec4(col, 1.0);
}