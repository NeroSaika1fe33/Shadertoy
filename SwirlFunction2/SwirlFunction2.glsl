vec3 hsl2rgb( in vec3 c )
{
    vec3 rgb = clamp( abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0, 1.0 );

    return c.z + c.y * (rgb-0.5)*(1.0-abs(2.0*c.z-1.0));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = (fragCoord - 0.5*iResolution.xy)/iResolution.y;
    vec2 p = fragCoord/iResolution.xy;
    //polar Coordinate
    vec2 polar;
    polar.y = sqrt(uv.x*uv.x + uv.y*uv.y);
    polar.x = atan(uv.y,uv.x);
    if(polar.x < 0.0)
    {
		polar.x += 6.28318530718;
    }
    float distortStrength = 0.2;
    vec2 offset = vec2(cos(polar.y * 6.28 + iTime), sin(polar.x * 10.0 + iTime)) * distortStrength * polar.y;
    vec3 col = texture(iChannel0,p + offset).rgb;
    polar.x /= 6.28318530718;
    float hue = polar.x*2.0+polar.y+iTime*0.5;
    vec3 rgb = hsl2rgb(vec3(hue,1.0,0.6));
    //col =mix(col,rgb,0.5);
    fragColor = vec4(col,1.0);
}