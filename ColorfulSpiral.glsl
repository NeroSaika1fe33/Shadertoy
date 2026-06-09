// HSL colorspace:
// https://www.shadertoy.com/view/XljGzV
vec3 hsl2rgb( in vec3 c )
{
    vec3 rgb = clamp( abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0, 1.0 );

    return c.z + c.y * (rgb-0.5)*(1.0-abs(2.0*c.z-1.0));
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    
    // normalized
    vec2 p = vec2(fragCoord.xy / iResolution.xy);
    
    // Polar coordinates:
    // https://www.shadertoy.com/view/ltlXRf
    vec2 relativePos = fragCoord.xy - (iResolution.xy / 2.0);
    vec2 polar;
    polar.y = sqrt(relativePos.x * relativePos.x + relativePos.y * relativePos.y);
    polar.y /= iResolution.x / 2.0;
    polar.y = 1.0 - polar.y;

    polar.x = atan(relativePos.y, relativePos.x);
    //polar.x -= 1.57079632679;
    if(polar.x < 0.0){
		polar.x += 6.28318530718;
    }
    polar.x /= 6.28318530718;
    polar.x = 1.0 - polar.x;
    
    // Compute swirl:
    float hue = polar.x * 2.0 + iTime * 0.3 + polar.y;
    
    // Compute rgb:
    vec3 rgb = hsl2rgb(vec3(hue, 1.0, 0.6));
    fragColor = vec4(rgb, 1.0);
}