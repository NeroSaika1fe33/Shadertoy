// void mainImage(out vec4 fragColor, in vec2 fragCoord)
// {
//     vec2 uv =(fragCoord-0.5*iResolution.xy)/iResolution.y;

// }

// p: 当前像素坐标
// b: 矩形的半长宽（如 vec2(0.5, 0.3)）
// r: 圆角半径
float sdRoundedBox(vec2 p, vec2 b, float r) {
    vec2 q = abs(p) - b + r;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // 1. 坐标准备
    // uv: 0 到 1，用于采样纹理
    vec2 uv = fragCoord / iResolution.xy;
    // p: 中心化坐标，用于计算 SDF 形状
    vec2 p = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;

    // 2. 定义蒙版参数
    vec2 size = vec2(0.4, 0.25); // 蒙版尺寸
    float radius = 0.08;        // 圆角程度
    
    // 3. 计算距离场 d
    float d = sdRoundedBox(p, size, radius);

    // 4. 生成平滑蒙版信号 (Alpha)
    // 利用 smoothstep 实现抗锯齿
    float mask = smoothstep(0.002, 0.0, d);

    // 5. 内部色彩与渐变 (模拟苹果玻璃蒙版的边晕)
    // 越靠近中心，亮绿色越强
    float innerGlow = clamp(abs(d) * 3.0, 0.0, 1.0);
    vec3 overlayCol = mix(vec3(0.5, 0.8, 1.0), vec3(1.0), innerGlow);

    // 6. 采样纹理 iChannel0
    // 我们直接使用 uv，图片会铺满全屏，但只在蒙版内可见
    vec4 tex = texture(iChannel0, uv);

    // 7. 最终合成
    // 我们将贴图颜色与我们的渐变颜色进行“柔光”或“相乘”处理
    // 如果你只想看纯贴图，可以直接用 tex.rgb
    vec3 finalRGB = tex.rgb * overlayCol;
    
    // 应用蒙版：RGB * mask 并在 Alpha 通道也填入 mask
    // 这样背景就会是纯黑（或者你可以 mix 一个背景色）
    fragColor = vec4(finalRGB * mask, mask); 
    
    // 可选：给蒙版加一个细微的白色描边
    float border = smoothstep(0.005, 0.0, abs(d) - 0.002);
    fragColor.rgb = mix(fragColor.rgb, vec4(1.0).rgb, border);
}