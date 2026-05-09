// void mainImage(out vec4 fragColor,in vec2 fragCoord)
// {
//     vec2 uv=fragCoord.xy/iResolution.y;
//     vec2 texel=1.0/iResolution.xy;
//     //伪代码
//     vec4 data=texture(iChannel0,uv);
//     float h=data.r;
//     float u=data.g;
//     float v=data.b;

//     float h_up=texture(iChannel0,uv+vec2(0.0,1.0)).r;
//     float h_down=texture(iChannel0,uv+vec2(0.0,-1.0)).r;
//     float h_left=texture(iChannel0,uv+vec2(-1.0,0.0)).r;
//     float h_right=texture(iChannel0,uv+vec2(1.0,0.0)).r;

//     float sum_h=(4.0*h-h_up-h_down-h_left-h_right)*0.25;

//     //流速公式
//     float u_now=(u,v);

//     float h_now=h+u;
    
//     float h_now*=0.999;

//     float v_now=(h,v);

//     if(iMouse>0.0){
//                 float d = length(fragCoord.xy - iMouse.xy);
//         if (d < 10.0) 
//         {
//             h_now = 1.0; 
//         }
//     }

//     fragColor=(h_now,u_now,v_now,1.0);
// }

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord.xy / iResolution.xy; // 统一用 xy 保证采样准确
    vec2 texel = 1.0 / iResolution.xy;
    
    // 1. 读取当前像素的 状态 (h, u, v)
    // r: height, g: velocity_x (u), b: velocity_y (v)
    vec4 data = texture(iChannel0, uv);
    float h = data.r;
    float u = data.g;
    float v = data.b;

    // 2. 采样四周的高度 (用于计算加速度)
    float h_up    = texture(iChannel0, uv + vec2(0.0, texel.y)).r;
    float h_down  = texture(iChannel0, uv - vec2(0.0, texel.y)).r;
    float h_left  = texture(iChannel0, uv - vec2(texel.x, 0.0)).r;
    float h_right = texture(iChannel0, uv + vec2(texel.x, 0.0)).r;

    // 3. 采样四周的流速 (用于计算高度变化)
    float u_left  = texture(iChannel0, uv - vec2(texel.x, 0.0)).g;
    float u_right = texture(iChannel0, uv + vec2(texel.x, 0.0)).g;
    float v_up    = texture(iChannel0, uv + vec2(0.0, texel.y)).b;
    float v_down  = texture(iChannel0, uv - vec2(0.0, texel.y)).b;

    // --- 核心物理计算 ---

    // 参数调整：dt 是时间步长，visc 是粘度
    float dt = 0.5; 
    float visc = 0.995;

    // A. 计算新的流速 (坡度驱动)
    // 高度差越大，加速度越大
    float u_now = (u + (h_left - h_right) * dt) * visc;
    float v_now = (v + (h_down - h_up) * dt) * visc;

    // B. 计算新的高度 (流量驱动)
    // 这里的逻辑是：左边往右推的水 - 我往右边推的水 + 下边往上推的水 - 我往上面推的水
    float h_now = h + (u_left - u_right + v_down - v_up) * dt;
    
    // 能量微弱衰减
    h_now *= 0.998;

    // --- 交互与边界 ---

    // 障碍物判定 (重用你之前的逻辑)
    // if(inObstacle) { h_now = 0.0; u_now = 0.0; v_now = 0.0; }

    if(iMouse.z > 0.0){
        float d = length(fragCoord.xy - iMouse.xy);
        if (d < 10.0) {
            h_now = 1.0; 
        }
    }

    // 存储：R=高度, G=X流速, B=Y流速
    fragColor = vec4(h_now, u_now, v_now, 1.0);
}