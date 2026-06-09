// 模拟 Unity 中的 Properties
// iChannel0: Main Texture (暗面贴图)
// iChannel1: Light Texture (亮面贴图)

// 自定义配置 (对应 Unity 的 _LightVector 和 _Color)
#define LIGHT_VECTOR normalize(vec3(1.0, 1.0, 0.0))
#define TINT_COLOR vec4(1.0, 1.0, 1.0, 1.0)

// 获取球体的法线 (用于模拟 Mesh Normal)
vec3 getNormal(vec2 uv) {
    float r = 0.8; // 球体半径
    vec2 p = uv * 2.0 - 1.0; // 将 UV 映射到 -1 到 1
    float z2 = r * r - dot(p, p);
    
    if (z2 < 0.0) return vec3(0.0); // 背景部分
    return normalize(vec3(p, sqrt(z2)));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // 归一化坐标 (0 到 1)
    vec2 uv = fragCoord / iResolution.xy;
    
    // 1. 计算法线 (模拟 Unity 的 v.normal)
    vec3 normal = getNormal(uv);
    
    // 如果不在球体范围内，渲染背景色
    if (length(normal) < 0.1) {
        fragColor = vec4(0.1, 0.1, 0.1, 1.0);
        return;
    }

    // 2. 计算光照强度 (对应 Unity 的 lightRate)
    // lightRate = saturate(dot(normal, lightDirection))
    float lightRate = clamp(dot(normal, LIGHT_VECTOR), 0.0, 1.0);
    
    // 3. 采样贴图 (对应 Unity 的 tex2D)
    vec4 mainColor = texture(iChannel0, uv);
    vec4 lightColor = vec4(1.0,0.2,0.5,1.0); // 亮面贴图可以是纯白色，或者根据需要采样 iChannel1
    
    // 4. 线性插值混合 (对应 Unity 的 color 混合逻辑)
    // color = mainColor * (1.0 - lightRate) + lightColor * lightRate
    vec4 finalColor = mix(mainColor, lightColor, lightRate);
    
    // 5. 应用颜色叠加
    fragColor = finalColor * TINT_COLOR;
}