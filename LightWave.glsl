void mainImage(out vec4 fragColor,in vec2 fragCoord)
{
    vec2 uv = (fragCoord - 0.5 * iResolution.xy)/iResolution.y;
    vec3 col = vec3(1.0);
    float battery= fract(iTime);
    float ball1 = smoothstep(battery-0.1, battery, length(uv));
    float light1 = smoothstep(battery+0.1, battery, length(uv));
    col = vec3(0.2,0.5,0.7);
    float ball2 = smoothstep(battery-0.5, battery, length(uv));
    float light2 = smoothstep(battery+0.1, battery, length(uv));
    col += mix(vec3(0.0,0.0,0.0),col,ball1*light1);
    col += mix(vec3(1.0,0.0,0.0),col,ball2*light2);
    fragColor = vec4( col , 1.0);
}