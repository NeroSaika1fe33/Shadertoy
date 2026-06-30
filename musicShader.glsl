void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord / iResolution.xy;
    
    // 1. 将屏幕水平切分成 30 个柱子 (量化)
    float numBars = 30.0;
    float barId = floor(uv.x * numBars) / numBars;
    
    // 2. 对数化采样，让视觉分布更均匀好看
    float logX = (pow(2.0, barId) - 1.0);
    float fft = texture(iChannel0, vec2(logX, 0.25)).r;
    
    // 3. 绘制柱子的高度
    // 每一个柱子内部留一点点间距 (gap)
    float barMask = step(uv.y, fft);
    float gapMask = step(0.1, fract(uv.x * numBars));
    float finalMask = barMask * gapMask;
    
    // 4. 渐变调色：低频青色，高频红色
    vec3 col = mix(vec3(0.0, 1.0, 0.6), vec3(1.0, 0.0, 0.3), uv.x);
    col *= finalMask;
    
    fragColor = vec4(col, 1.0);
}