float sdbox(vec2 p, vec2 b)
{
    vec2 d = abs(p) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

float sun(vec2 uv, float battery)
{
 	float val = smoothstep(0.3, 0.29, length(uv));
 	float bloom = smoothstep(0.7, 0.0, length(uv));
    float cut = 3.0 * sin((uv.y + iTime * 0.2 * (battery + 0.02)) * 100.0) 
				+ clamp(uv.y * 14.0 + 3.0, -6.0, 6.0);
    cut = clamp(cut, 0.0, 1.0);
    return clamp(val * cut, 0.0, 1.0) + bloom * 0.3;
}

void mainImage(out vec4 fragColor,in vec2 fragCoord)
{
    vec2 uv =(fragCoord-0.5*iResolution.xy)/iResolution.y;
    vec3 col = vec3(1.0);
    col *= smoothstep(0.1,0.09,sdbox(uv,vec2(0.25,0.15)));
    col = mix(col,vec3(1.0,0.0,0.0),sun(uv/0.3,1.0)+sdbox(uv,vec2(0.8,0.3)));
    fragColor=vec4(col,1.0);
}