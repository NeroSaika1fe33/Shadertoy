#define PI 3.14159265359

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 polar;

    vec2 center = vec2(0.5);
    center = iMouse.xy/iResolution.xy;
    center = center == vec2(0., 0.) ? vec2(.5, .5) : center;

    //the center will be set by mouse position or defaultly in the middle
    vec2 uv = fragCoord.xy / iResolution.xy - center;

    //Build a round based on real axis instead of screen axis with unsame x and y
    float len = length(uv * vec2(iResolution.x / iResolution.y, 1.));

    float FXradius1 = .5;
    float FXradius2 = 0.;
    polar.x = atan(uv.y,uv.x);
    polar.y = length(uv);

    //Use smoothstep to make the swirl effect based on distance to center with two patterns
    polar.x +=  mod(iTime,4.0)*.5 * PI* smoothstep(FXradius1,FXradius2,len);

    //Texture color with polar coordinates and center offset
    vec3 col = texture(iChannel0,vec2(polar.y*cos(polar.x),polar.y*sin(polar.x))+center).rgb;
    fragColor = vec4(col,1.0);
}