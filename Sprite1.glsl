void mainImage(out vec4 fragColor,in vec2 fragCoord)
{
    vec2 uv = (fragCoord-0.5 * iResolution.xy)/iResolution.y;
    float cardlength = 0.45;
    float cardwidth = 0.3;
    if(cardlength/2.0 > abs(uv.y) && abs(sin(iTime))*cardwidth/2.0 > abs(uv.x))
    {
        if(sin(iTime) > 0.0)
        {
            fragColor = vec4(0.0, 0.0, 1.0, 1.0);
        if(abs(uv.x)<abs(sin(iTime))*cardwidth/2.0-0.01 && abs(uv.y)<cardlength/2.0-0.015)
        {
            fragColor = vec4(0.0, 0.0, 0.0, 1.0);
        }
        }
        else
        {
            fragColor = vec4(0.0, 0.5, 0.2, 1.0);
        }
        vec3 n=vec3(0.0,0.0,1.0);
    }
    else
    {
        fragColor = vec4(1.0, 1.0, 1.0, 1.0);
    }
}