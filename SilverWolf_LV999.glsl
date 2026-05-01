#iChannel0 "file://assets//123.png"

// 模拟 Blender 中的逻辑：将线性增长转化为序列帧坐标
vec2 getSequenceUV(vec2 uv, float linearVal, vec2 gridRes) {
    // 1. 对应第一个 Wrap 36.0 和 Snap/Floor 逻辑
    float totalFrames = gridRes.x * gridRes.y;
    float frameIndex = mod(floor(linearVal), totalFrames);
    
    // 2. 计算当前帧所在的行(y)和列(x)
    // 对应第一排节点计算 X
    float col = mod(frameIndex, gridRes.x);
    // 对应第二排节点计算 Y (注意 Multiply -1.0 逻辑)
    float row = floor(frameIndex / gridRes.x);
    
    // 3. 将原始 UV 缩放到单个格子的尺寸 (假设 Mapping 节点的 Scale 是 2.0，这里对应 1.0/gridRes)
    // 如果你在 Blender 里 Scale 是 2，那这里就是 uv * 0.5
    vec2 scaledUV = uv / gridRes;
    
    // 4. 计算偏移量 (每格的大小是 1.0 / gridRes)
    // y轴取负是为了从上往下换行，符合大多数序列帧图集标准
    vec2 offset = vec2(col, -row) / gridRes;
    
    // 5. 加上一个初始补偿（取决于贴图第一帧在左上还是左下，通常 Y 轴需要加一个 (gridRes.y-1)/gridRes）
    offset.y += (gridRes.y - 1.0) / gridRes.y;
    
    return scaledUV + offset;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // --- 坐标初始化 ---
    vec2 uv = fragCoord/iResolution.xy;
    
    // --- 模拟 0-255 的线性递增输入 (对应你最左边的紫色节点) ---
    // 这里用 iTime 驱动，速度可以自行调节
    float speed = 15.0; 
    float linearInput = mod(iTime * speed, 256.0);
    
    // --- 矢量计算部分：序列帧 UV 映射 ---
    vec2 gridRes = vec2(6.0, 6.0); // 6x6 网格
    vec2 finalUV = getSequenceUV(uv, linearInput, gridRes);
    
    // --- 纹理采样 (对应 图像纹理 节点) ---
    // 请在 Shadertoy 的 iChannel0 中放入你的序列帧贴图
    vec4 texColor = texture(iChannel0, finalUV);
    
    // --- 材质逻辑部分 ---
    
    // 1. 发光强度 (对应 组输入 节点)
    float emissionStrength = 1.0; 
    
    // 2. 自发光计算 (Emission = Color * Strength)
    vec3 emission = texColor.rgb * emissionStrength;
    
    // 3. 混合着色器 (Mix Shader)
    // 逻辑：mix(透明BSDF, 自发光, Alpha系数)
    // 透明在 Shader 里通常表现为黑色(0,0,0)或者是让背景透过
    vec3 finalRGB = mix(vec3(0.05), emission, texColor.a);
    
    // --- 最终输出 (对应 材质输出 节点) ---
    // 如果背景需要透明，Alpha 通道很重要
    fragColor = vec4(finalRGB, texColor.a);
}