void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec2 texel = 1.0 / iResolution.xy;

    // 1. 读取历史数据
    vec4 data = texture(iChannel0, uv);
    float h_last = data.r; // 上一帧高度
    float h_prev = data.g; // 上上帧高度

    // 2. 采样四周邻居的高度（扩散逻辑）
    float h_up    = texture(iChannel0, uv + vec2(0, texel.y)).r;
    float h_down  = texture(iChannel0, uv - vec2(0, texel.y)).r;
    float h_left  = texture(iChannel0, uv - vec2(texel.x, 0)).r;
    float h_right = texture(iChannel0, uv + vec2(texel.x, 0)).r;

    // 3. 波动方程：新高度 = 邻居平均 - 远古高度
    float h_now = (h_up + h_down + h_left + h_right) * 0.5 - h_prev;

    // 4. 阻尼（能量损耗，防止永远跳动）
    h_now *= 0.99;

    // 5. 注入能量（鼠标点击）
    if (iMouse.z > 0.0) {
        float d = length(fragCoord.xy - iMouse.xy);
        if (d < 5.0) h_now = 1.0; 
    }

    // 6. 保存状态
    fragColor = vec4(h_now, h_last, 0.0, 1.0);
}