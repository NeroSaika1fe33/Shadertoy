void mainImage(out vec4 fragColor,in vec2 fragCoord)
{
    vec2 uv =(fragCoord-0.5*iResolution.xy)/iResolution.y;
    float d= sqrt(uv.x*uv.x+uv.y*uv.y);

    float round=smoothstep(0.1,0.11,d);
    vec3 col=mix(vec3(1.0,0.0,0.0),vec3(1.0,1.0,1.0),round);
    fragColor=vec4(col,1.0);
}