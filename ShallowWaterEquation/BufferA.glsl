// #iChannel0 "self"

// 简单的圆形距离函数
float sdCircle(vec2 p, vec2 center, float r) {
    return length(p - center) - r;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec2 texel = 1.0 / iResolution.xy;

    // 1. 读取当前像素状态: r=高度, g=U流速, b=V流速
    vec4 data = texture(iChannel0, uv);
    float h = data.r;
    float u = data.g;
    float v = data.b;

    // 2. 采样相邻像素
    float hL = texture(iChannel0, uv - vec2(texel.x, 0.0)).r;
    float hR = texture(iChannel0, uv + vec2(texel.x, 0.0)).r;
    float hD = texture(iChannel0, uv - vec2(0.0, texel.y)).r;
    float hU = texture(iChannel0, uv + vec2(0.0, texel.y)).r;
    
    float uL = texture(iChannel0, uv - vec2(texel.x, 0.0)).g;
    float uR = texture(iChannel0, uv + vec2(texel.x, 0.0)).g;
    float vD = texture(iChannel0, uv - vec2(0.0, texel.y)).b;
    float vU = texture(iChannel0, uv + vec2(0.0, texel.y)).b;

    // --- 物理核心计算 ---
    float dt = 0.15;      // 步长
    float visc = 0.98;    // 粘度
    
    // 加速度驱动流速
    float u_now = (u + (hL - hR) * dt) * visc;
    float v_now = (v + (hD - hU) * dt) * visc;
    
    // 流量驱动高度
    float h_now = (h + (uL - uR + vD - vU) * dt) * 0.998;

    // --- 排水口逻辑 (不造波的吸收器) ---
    vec2 drainPos = iResolution.xy * vec2(0.8, 0.2); // 定位在右下角
    float dDrain = length(fragCoord - drainPos);
    if (dDrain < 40.0) {
        float absorb = smoothstep(40.0, 0.0, dDrain);
        // 关键：不强行设高度，而是对所有变量做剧烈乘法衰减
        h_now *= (1.0 - absorb * 0.6);
        u_now *= (1.0 - absorb * 0.9);
        v_now *= (1.0 - absorb * 0.9);
    }

    // --- 障碍物逻辑 (深灰色圆柱) ---
    vec2 obsPos = iResolution.xy * 0.45;
    float dObs = sdCircle(fragCoord, obsPos, 60.0);
    if (dObs < 0.0) {
        h_now = 0.0; u_now = 0.0; v_now = 0.0;
    }

    // --- 交互造波 (鼠标左键) ---
    if (iMouse.z > 0.5) {
        float dMouse = length(fragCoord - iMouse.xy);
        if (dMouse < 15.0) h_now += 0.4;
    }

    // 数值安全截断，防止飞走
    h_now = clamp(h_now, -1.0, 2.0);
    u_now = clamp(u_now, -0.8, 0.8);
    v_now = clamp(v_now, -0.8, 0.8);

    fragColor = vec4(h_now, u_now, v_now, 1.0);
}