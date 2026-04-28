float myHash(vec2 p)
{
    p=p*vec2(123.45, 678.91);
    p+=dot(p, p+114.514);
    return fract(p.x*p.y);
}

float myNoise(vec2 p)
{
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);

    float a = myHash(i);
    float b = myHash(i + vec2(1.0, 0.0));
    float c = myHash(i + vec2(0.0, 1.0));
    float d = myHash(i + vec2(1.0, 1.0));

    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void mainImage(out vec4 fragColor,in vec2 fragCoord)
{
    vec2 uv = fragCoord/iResolution.xy;
    if(mod(uv.x*100.0,10.0)==floor(uv.x*100.0))
    {
        fragColor=vec4(255, 0, 0, 1.0);
    }
    else
    {
        fragColor=vec4(255, 255, 255, 1.0);
    }
}