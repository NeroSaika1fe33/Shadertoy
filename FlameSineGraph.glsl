#define PI 3.14159265359

vec3 palette(in float t) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.1, 0.4, 0.5);
    return a + b * cos(2.0 * PI * (c * t + d));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = (fragCoord.xy - 0.5 * iResolution.xy) / iResolution.y;
    vec3 col = vec3(0.0);
    for(float f = 0.0; f < 5.0; f += 0.5)
    {    
        float func = sin(uv.x-2.0);
        float thick = 1.0 + pow(abs(uv.x), 0.001);
        float sinValue1 = smoothstep(0.03,0.0,abs(uv.y-0.3*sin(uv.x*f*10.0+iTime*5.0)/thick));
        float line = sinValue1/thick;
        col = mix(col,vec3(sin(iTime),-sin(iTime),cos(iTime)),line);
    }
    fragColor = vec4(col, 1.0);
}