// 简易哈希/距离函数：计算点到线段的距离（用于画线）
float dfLine(vec2 p, vec2 a, vec2 b) {
    vec2 pa = p - a, ba = b - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h);
}

// 旋转矩阵
mat3 rotateY(float theta) {
    float c = cos(theta), s = sin(theta);
    return mat3(c, 0, -s, 0, 1, 0, s, 0, c);
}
mat3 rotateX(float theta) {
    float c = cos(theta), s = sin(theta);
    return mat3(1, 0, 0, 0, c, -s, 0, s, c);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    // 1. 坐标归一化与比例校正
    vec2 p = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    vec3 col = vec3(0.0); // 黑色背景

    // 2. 准确定义正方体的 8 个顶点 (将中心对齐到原点，边长为 1)
    vec3 vertex[8];
    int idx = 0;
    for(int i = 0; i < 2; i++) {
        for(int j = 0; j < 2; j++) {
            for(int k = 0; k < 2; k++) {
                // 将 0,1 映射到 -0.5, 0.5，让立方体围绕中心旋转
                vertex[idx] = vec3(float(i)-0.5, float(j)-0.5, float(k)-0.5);
                idx++;
            }
        }
    }

    // 3. 摄像机与透视投影设置
    float camDist = 2.5; // 相机距离原点的距离
    float fov = 1.2;     // 焦距 (Focal Length)，控制透视强弱
    
    // 让立方体随时间旋转
    mat3 rot = rotateY(iTime * 0.6) * rotateX(iTime * 0.4);

    // 4. 顶点着色器阶段：3D 变换并投影到 2D 屏幕
    vec2 p2d[8];
    for(int i = 0; i < 8; i++) {
        // 世界变换 (旋转)
        vec3 v = rot * vertex[i];
        
        // 视口变换：将物体推到摄像机前方 (Z轴负方向或正方向，这里选择将物体放在 Z = -camDist 处)
        float z = v.z - camDist; 
        
        // 核心透视除法：X' = X / Z, Y' = Y / Z
        // Z 越深（负得越多），除出来的坐标越小，形成“近大远小”
        p2d[i] = (v.xy / (-z)) * fov; 
    }

    // 5. 光栅化阶段：定义立方体的 12 条棱，并画线
    // 每一个数字代表顶点数组 vertex 的索引
    int lines[24] = int[](
        0,1, 1,3, 3,2, 2,0, // 前后面
        4,5, 5,7, 7,6, 6,4, 
        0,4, 1,5, 2,6, 3,7  // 连接前后的侧边
    );

    float minD = 1e5;
    for(int i = 0; i < 24; i += 2) {
        int i1 = lines[i];
        int i2 = lines[i+1];
        // 计算当前像素到该棱投影线段的距离
        float d = dfLine(p, p2d[i1], p2d[i2]);
        minD = min(minD, d);
    }

    vec3 normal = normalize(cross(vertex[0] - vertex[1], vertex[0] - vertex[2])); 
    if(normal.z < 0.0) {
        col += vec3(0.0, 0.5, 1.0) * smoothstep(0.004, 0.0, (1.0 - normal.z)); 
    } else {
        col += vec3(1.0, 0.5, 0.0) * smoothstep(0.004, 0.0, (1.0 + normal.z)); 
    }

    // 6. 棱线抗锯齿输出
    float edge = smoothstep(0.004, 0.0, minD);
    col += vec3(0.0, 1.0, 0.6) * edge; // 青绿色线框
    col += vec3(0.0, 0.5, 0.3) * edge * normal.z; 
    fragColor = vec4(col, 1.0);
}