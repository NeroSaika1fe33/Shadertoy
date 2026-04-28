void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    vec3 col = vec3(0.0);
    float t = fract(iTime * 0.5); 

    // lerp
    vec2 p0 = vec2(0.4, 0.4);
    vec2 p1 = vec2(-0.4, 0.4);
    float t_linear = t; 
    vec2 posA = mix(p0, p1, t_linear);
    col += (0.01 / length(uv - posA)) * vec3(1.0, 0.3, 0.3); // red

    //ease in (acc up)
    vec2 p3 = vec2(0.4, 0.3);
    vec2 p4 = vec2(-0.4, 0.3);
    float t_ease = t * t ; 
    vec2 posB = mix(p3, p4, t_ease);
    col += (0.01 / length(uv - posB)) * vec3(0.3, 0.3, 1.0); // blue

    //smoothstep (ease in out)
    vec2 p5 = vec2(0.4, 0.2);
    vec2 p6 = vec2(-0.4, 0.2);
    float t_smooth = smoothstep(0.0, 1.0, t); 
    
    vec2 posC = mix(p5, p6, t_smooth);
    col += (0.01 / length(uv - posC)) * vec3(0.3, 1.0, 0.3); // green

    //quadratic bazier
    //B(t)=(1-t)^3 * P0 + 2t(1-t)^2 * P1 + t^2 * P2
    vec2 p7 = vec2(0.4,-0.2);
    vec2 p8 = vec2(-0.4,-0.2);
    vec2 control = vec2(0.0, 0.2);
    vec2 currentpos1 = (1.0-t)*(1.0-t)*p7 + 
                        2.0*t*(1.0-t)*control + 
                        t*t*p8;
    col += (0.01 / length(uv - currentpos1)) * vec3(1.0, 1.0, 0.3); // yellow

    //cubic bazier
    //B(t)=(1-t)^3 * P0 + 3t(1-t)^2 * P1 + 3t^2(1-t)*P2 + t^3 * P3
    vec2 p9 = vec2(0.4, -0.4);
    vec2 p10 = vec2(-0.4, -0.4);
    vec2 control1 = vec2(0.0, 0.2);
    vec2 control2 = vec2(-0.4, 0.2);
    vec2 currentpos2 = (1.0-t)*(1.0-t)*(1.0-t)*p9+
                        3.0*t*(1.0-t)*(1.0-t)*control1+
                        3.0*t*t*(1.0-t)*control2+
                        t*t*t*p10;
    col += (0.01 / length(uv - currentpos2)) * vec3(1.0, 1.0, 1.0); // white

    //start and end points
    col += 0.002 / length(uv - p0); col += 0.002 / length(uv - p1);
    col += 0.002 / length(uv - p3); col += 0.002 / length(uv - p4);
    col += 0.002 / length(uv - p5); col += 0.002 / length(uv - p6);
    col += 0.002 / length(uv - p7); col += 0.002 / length(uv - p8);
    col += 0.002 / length(uv - p9); col += 0.002 / length(uv - p10);

    fragColor = vec4(col, 1.0);
}