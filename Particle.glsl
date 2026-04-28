float Myhash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    vec3 finalCol= vec3(0.0);
    float yd=0.5;
    for(float i=0.0;i<30.0;i++)
    {
    float d = length(uv+vec2(Myhash(vec2(cos(iTime*8.0)*i,123.456))-0.5, 0.5*sin(iTime)));
    float brightness = 0.003 + 0.001 * sin(iTime * 5.0); 
    float spark = brightness / d;

    vec3 col = vec3(0.5 + 0.5 * sin(iTime), 0.3, 1.0);

    finalCol += col * spark;
    fragColor=vec4(finalCol,1.0);
    }
}