float myHash(vec2 p)
{
    return fract(sin(dot(p, vec2(123.45, 456.78))) * 43758.5453123);
}

float myStep(float edge, float x)
{
if(x<edge)
    return 0.0;
if(x>=edge)
    return 1.0;
return 0.0;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
vec2 uv = fragCoord/iResolution.xy;
vec2 TilePos = floor(uv * 50.0);
float id = myHash(TilePos);
float blink = myStep(0.9, fract(iTime * 1.5 + id));
vec3 color = vec3(0.5 + 0.5 * id, 0.2, 1.0) * blink; 
vec2 glid=fract(uv*50.0);
float line =smoothstep(0.4, 0.6, glid.x) * smoothstep(0.4, 0.6, glid.y);
fragColor = mix(vec4(1.0), vec4(1.0, 0.0, 0.0, 1.0), clamp(line, 0.0, 1.0))+vec4(color, 1.0);
//fragColor=vec4(color,1.0);
}