// #iChannel0 "self"
// --- 逻辑存在于 Buffer A 中 ---
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord / iResolution.xy;
    vec2 texel = 1.0 / iResolution.xy;

    // 1. 读取周围像素的高度 (当前帧)
    float h_up    = texture(iChannel0, uv + vec2(0, texel.y)).r;
    float h_down  = texture(iChannel0, uv - vec2(0, texel.y)).r;
    float h_left  = texture(iChannel0, uv - vec2(texel.x, 0)).r;
    float h_right = texture(iChannel0, uv + vec2(texel.x, 0)).r;
    
    // 2. 读取当前点上一帧的高度 (储存在 g 或 b 通道)
    float h_last  = texture(iChannel0, uv).g;

    // 3. 波动方程核心计算
    // 这里的 0.5 是波速控制
    float h_now = (h_up + h_down + h_left + h_right) * 0.5 - h_last;

    // 4. 处理反弹 (边界条件)
    // 如果靠近边缘，强制能量衰减或反向
    if (fragCoord.x < 1.0 || fragCoord.x > iResolution.x - 1.0 ||
        fragCoord.y < 1.0 || fragCoord.y > iResolution.y - 1.0) {
        h_now *= -0.8; // 简单的反转震动模拟反弹
    }

    // 5. 加上衰减，防止能量爆炸
    h_now *= 0.99;

    // 6. 交互：如果鼠标按下，在坐标处产生一个“凹陷”作为波源
    if(iMouse.z > 0.0) {
        float dist = length(fragCoord - iMouse.xy);
        if(dist < 5.0) h_now = 1.0;
    }

    // 保存状态：r 存当前高度，g 存上一帧高度供下一帧使用
    fragColor = vec4(h_now, texture(iChannel0, uv).r, 0.0, 1.0);
}