void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    vec2 pos = vec2(0.0, 0.0);
    vec2 p = uv - pos;
    float d = max(abs(p.x), abs(p.y));

    float brightness = 0.01*abs(0.5 * sin(iTime * 5.0)); 
    float spark = brightness / d;

    vec3 col = vec3(0.0, 1.0, 0.8) * spark; 
    fragColor = vec4(col, 1.0);
}