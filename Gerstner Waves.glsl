//Generate by gemini
// 单个 Gerstner 波函数
// p: 原始位置, amplitude: 振幅, dir: 方向, steepness: 陡峭度, freq: 频率
vec3 gerstner(vec2 p, float amplitude, vec2 dir, float steepness, float freq, float speed) {
    float phase = dot(dir, p) * freq + iTime * speed;
    float cosP = cos(phase);
    float sinP = sin(phase);
    
    // Q 是陡峭度归一化处理
    float Q = steepness / (amplitude * freq);
    
    return vec3(
        Q * amplitude * dir.x * cosP, // X 轴偏移
        Q * amplitude * dir.y * cosP, // Y 轴偏移
        amplitude * sinP              // Z 轴高度
    );
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    
    // 叠加三个不同方向的波
    vec3 waveRes = vec3(0.0);
    waveRes += gerstner(uv, 0.08, vec2(1.0, 0.0), 0.5, 10.0, 2.5);
    waveRes += gerstner(uv, 0.05, vec2(0.7, 0.7), 0.3, 15.0, 3.0);
    waveRes += gerstner(uv, 0.03, vec2(0.0, 1.0), 0.2, 20.0, 1.5);
    
    // 在 2D 俯视图中，我们可以用 X/Y 的位移来偏移 UV 采样，模拟折射
    vec2 distortedUV = uv + waveRes.xy * 0.5;
    
    // 利用高度 Z 来计算光照
    float h = waveRes.z;
    vec3 col = mix(vec3(0.01, 0.1, 0.2), vec3(0.1, 0.6, 0.8), h * 5.0 + 0.5);
    
    // 模拟高光
    float spec = pow(max(h * 5.0 + 0.5, 0.0), 15.0);
    col += spec * 0.4;

    fragColor = vec4(col, 1.0);
}