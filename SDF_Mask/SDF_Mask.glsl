//Create a renctangular SDF mask
float sdRoundedBox(vec2 p, vec2 b, float r) {
    vec2 q = abs(p) - b + r;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec2 center = vec2 (0.5);

    center = iMouse.xy/iResolution.xy;
        
    vec2 size = vec2(0.2, 0.2); 
    float radius = 0.08;      
    
    float d = sdRoundedBox(uv - center, size, radius);
    vec4 tex = texture(iChannel0, uv);
    float mask = smoothstep(0.002, 0.0, d);

    vec3 Col = mix(vec3(0.5, 0.8, 1.0), vec3(1.0), d);
    Col = tex.rgb * Col;
    fragColor = vec4(Col * mask, 1.0); 

    if(d>0.01)fragColor.rgb=tex.rgb*0.5;

    float border = smoothstep(0.005, 0.0, abs(d) - 0.008);
    fragColor.rgb = mix(fragColor.rgb, vec3(0.2,0.2,0.5), border);
}