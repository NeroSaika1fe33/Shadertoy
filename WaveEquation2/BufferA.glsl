// 在文件最开头添加这行，告诉插件：iChannel0 就是这个文件本身
// #iChannel0 "self"

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec2 texel = 1.0 / iResolution.xy;

    // 1. 读取邻居高度 (当前帧)
    float h_up    = texture(iChannel0, uv + vec2(0, texel.y)).r;
    float h_down  = texture(iChannel0, uv - vec2(0, texel.y)).r;
    float h_left  = texture(iChannel0, uv - vec2(texel.x, 0)).r;
    float h_right = texture(iChannel0, uv + vec2(texel.x, 0)).r;
    
    // 2. 读取旧数据：r 通道存的是高度，g 通道存的是“上一帧的高度”
    vec4 oldData = texture(iChannel0, uv);
    float h_prev = oldData.r;
    float h_last = oldData.g; // 实际上是上上帧

    // 3. 波动方程公式
    float h_now = (h_up + h_down + h_left + h_right) * 0.5 - h_last;
    
    // 4. 阻尼 (Damping) - 能量损耗，防止无限反弹
    h_now *= 0.98;

    // 5. 交互：鼠标点击产生波源
    if(iMouse.z > 0.0) {
        float d = length(fragCoord - iMouse.xy);
        if(d < 5.0) h_now = 1.0;
    }

    // 6. 存储结果：
    // r = 当前算出的新高度
    // g = 把刚才的“当前高度”传下去，变成下一帧的“上一帧高度”
    fragColor = vec4(h_now, h_prev, 0.0, 1.0);
}