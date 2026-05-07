float sdBox(vec2 p, vec2 b, vec2 pos) {
    vec2 d = abs(p - pos) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    
    vec2 b = vec2(0.25, 0.25); 
    vec2 pos = vec2(0.2, 0.2);

    float d = sdBox(uv, b, pos);

    float brightness = 0.006 + 0.002 * sin(iTime * 4.0);
    float spark = brightness / (abs(d) + 0.002);
    vec3 glowCol = vec3(0.4, 0.2, 1.0) * spark;

    vec3 finalCol = glowCol;

    if (d < 0.0) {
        vec2 cardUV = (uv - (pos - b)) / (2.0 * b);
        vec3 tex = texture(iChannel0, cardUV).rgb;
        finalCol = (tex*vec3(0.5f,0.3f,0.5f) + glowCol * 0.5)*0.8;
    }
    fragColor = vec4(finalCol, 1.0);
}