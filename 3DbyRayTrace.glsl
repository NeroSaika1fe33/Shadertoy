// boxFunction from IQ: https://iquilezles.org/articles/intersectors/
vec2 boxIntersection( in vec3 ro, in vec3 rd, vec3 boxSize, out vec3 oNormal ) 
{
    vec3 m = 1.0/rd;
    vec3 n = m*ro;
    vec3 k = abs(m)*boxSize;
    vec3 t1 = -n - k;
    vec3 t2 = -n + k;
    float tN = max( max( t1.x, t1.y ), t1.z );
    float tF = min( min( t2.x, t2.y ), t2.z );
    if( tN>tF || tF<0.0) return vec2(-1.0);
    oNormal = (tN>0.0) ? step(vec3(tN),t1) : step(t2,vec3(tF));
    oNormal *= -sign(rd);
    return vec2( tN, tF );
}

mat3 rotY(float angle)
{
     return mat3(
        cos(angle),0.,sin(angle),
        0.,1., 0.,
       -sin(angle),0.,cos(angle)
    );
}

mat3 rotZ(float angle)
{
    return mat3(
        cos(angle),-sin(angle),0.,
        sin(angle),cos(angle),0.,
        0.,0.,1.
    );
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // 1. 标准像素坐标归一化 (-0.5 到 0.5)
    vec2 p = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    vec3 col = vec3(1.); 

    // 2. 设置光线追踪相机 (Raycasting Setup)
    vec3 ro = vec3(0.0, 0.0, 2.0);            // 相机放在 Z = 2 的位置
    vec3 rd = normalize(vec3(p, -1.0));       // 光线向屏幕内 (-Z) 射出

    // 为了让它动起来，我们可以手动让光线/摄像机绕着立方体旋转
    vec3 Rotmat = vec3(0.,iTime * 0.5,90.);
    
    ro = rotY(Rotmat.y) * ro * rotZ(Rotmat.z);
    rd = rotY(Rotmat.y) * rd * rotZ(Rotmat.z);

    // 3. 定义立方体尺寸并调用 IQ 的求交函数
    vec3 boxSize = vec3(0.4, 0.4, 0.4); // 边长为 0.8 的正方体
    vec3 normal;
    vec2 t = boxIntersection(ro, rd, boxSize, normal);

if(t.x > 0.0) 
    {
        // 1. 计算出光线在 3D 空间中撞击到立方体表面的“精准三维坐标”
        vec3 hitPos = ro + rd * t.x;
        
        // 2. 计算碰撞点到盒子边界的相对距离
        // boxSize 是 vec3(0.4)
        vec3 dToEdge = abs(boxSize - abs(hitPos));
        
        // 3. 如果某两个轴都非常靠近边界，说明在棱边上
        // 我们通过对距离进行排序或筛选来找出“棱”
        float min1 = min(dToEdge.x, dToEdge.y);
        float min2 = min(dToEdge.y, dToEdge.z);
        float min3 = min(dToEdge.z, dToEdge.x);
        
        // 边缘检测值：取最靠近两条轴边界的交集
        float edgeDist = max(min1, max(min2, min3));
        
        // 4. 做出发光线框效果
        // 0.01 是线条的物理宽度
        float borderLine = smoothstep(0.01, 0.0, edgeDist);
        
        // 基础光照颜色
        vec3 lightDir = normalize(vec3(0.5, 1.0, 0.5));
        float diff = max(dot(normal, lightDir), 0.0);
        vec3 cubeColor = vec3(0.05, 0.1, 0.9) * (diff + 0.2);
        
        // 混合：给边框涂上亮青色（Neon Cyan）
        vec3 edgeColor = vec3(0.0, 1.0, 0.8);
        col = mix(cubeColor, edgeColor, borderLine);
    }
    fragColor = vec4(col, 1.0);
}