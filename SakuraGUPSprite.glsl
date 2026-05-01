float myHash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 437108.104103);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = (fragCoord - iResolution.xy * 0.10) / iResolution.y;
    vec3 col = vec3(0.1);
    float t = fract(iTime * 0.2);
    const int particleAmount = 50;
    vec2 Startpoints[particleAmount];
    vec2 Endpoints[particleAmount];
    vec2 controlPoints1[particleAmount];
    vec2 controlPoints2[particleAmount];
    for(int i = 0; i < particleAmount; i++) {
        Startpoints[i] = vec2(myHash(vec2(float(i), 123.4106)),myHash(vec2(float(i), 4106.789)));
        Endpoints[i] = vec2(myHash(vec2(float(i), 4106.789)), myHash(vec2(float(i), 123.4106)));
        controlPoints1[i] = vec2(myHash(vec2(float(i), 2233.4455)),myHash(vec2(float(i), 6677.8899)));
        controlPoints2[i] = vec2(myHash(vec2(float(i), 2233.4455)), myHash(vec2(float(i), 6677.8899)));
    }

    for(int i = 0; i < particleAmount; i++) {
    vec2 p0 = Startpoints[i];
    vec2 p1 = Startpoints[i];
    vec2 control1 = controlPoints1[i];
    vec2 control2 = controlPoints2[i];
    vec2 currentpos = (1.0-t)*(1.0-t)*(1.0-t)*p0+
                        3.0*t*(1.0-t)*(1.0-t)*control1+
                        3.0*t*t*(1.0-t)*control2+
                        t*t*t*p1;
    col += (0.001 / length(uv - currentpos)) *vec3(abs(sin(iTime)), abs(cos(iTime)), abs(sin(iTime)));
    }
    fragColor = vec4(col, 0.8);
}