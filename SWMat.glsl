float myHash(vec2 p)
{
    p=p*vec2(123.45, 678.91);
    p+=dot(p, p+114.514);
    return fract(p.x*p.y);
}

// void mainImage(out vec4 fragColor, in vec2 fragCoord)
// {
//     vec2 uv = fragCoord/iResolution.xy;
//     vec2 rectSize = vec2(0.1, 0.12);
//     vec2 rectPos = vec2(0.5, 0.5);
//     vec2 p=uv-rectPos;
    
//     float d=max(abs(p.x),abs(p.y));
//     vec3 finalCol=vec3(0.0);
//     float brigtness=0.1+0.0001*sin(iTime*5.0);
//     float spark=brigtness/(d);


//     vec3 col = vec3(0.9 + 0.5 * sin(iTime), 0.6, 0.01);
//     finalCol += col * spark;

//     fragColor=vec4(finalCol,1.0);
// }

// 完美的长方形距离场函数 (SDF)
// p: 坐标, b: 长方形的半长宽 (如 vec2(0.3, 0.2))
float sdBox(vec2 p, vec2 b , vec2 pos) {
    vec2 d = abs(p - pos) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    
    vec2 b = vec2(0.25, 0.15 ); 
    vec2 pos = vec2(0.2, 0.2);

    if(length(uv.x+b.x)>abs(b.x-pos.x) || length(b.y+uv.y)>abs(b.y-pos.y)) {
    float d = abs(sdBox(uv, b, pos));
    
    float brightness = 0.006 + 0.002 * sin(iTime * 4.0);
    float spark = brightness / (d + 0.002);
    
    vec3 col = vec3(0.4, 0.2, 1.0) * spark; 
    
    fragColor = vec4(col, 1.0);
    }
    else{
        fragColor = vec4(1.0);
    }
}