vec2 myhash1(vec2 n)
{
    return fract(sin(vec2(
        dot(n,vec2(123.456,789.123)),
    dot(n,vec2(114.514,191.9810)))));
}

float myhash2(float n){return fract(sin(dot(n,123.456)*789.123));}

mat2 rot(float theta)
{
    float c = cos(theta);
    float s = sin(theta);
    return mat2(c,-s,
                s, c);
}

void mainImage(out vec4 fragColor,in vec2 fragCoord)
{
    vec2 uv = (fragCoord-0.5*iResolution.y) / iResolution.y;
    vec3 col = vec3(0.0);
    vec2 cut = myhash1(floor(vec2(uv.x+iTime*0.2, uv.y) * 25.0));
    //vec2 cut = myhash1(floor(vec2(sqrt(uv.y*uv.y+uv.x*uv.x),sqrt(uv.y*uv.y+uv.x*uv.x))*50.0));
    // vec2 dir1 = vec2(1.0, 1.0); //45 degree
    // vec2 dir2 = vec2(1.0, -1.0);//-45 degree
    // vec2 cut = myhash1(floor(vec2(dot(uv, dir1) , dot(uv, dir2))* 25.0));
    // vec2 cut = myhash1(floor(vec2(dot(uv, vec2(1.0)),dot(uv, vec2(1.0,-1.0)))*25.0))
    // *myhash1(floor(vec2(sqrt(uv.y*uv.y+uv.x*uv.x),sqrt(uv.y*uv.y+uv.x*uv.x))*50.0));
    float lightness = 0.0;
    float d=0.0;
    for(float i = 0.0 ; i< 20.0 ; i++)
    {
        mat2 rotator = rot(iTime);
        vec2 line = vec2(uv.y,uv.x);
        //give frame a minimum lightness
        d = length(uv-line*rotator*rot(myhash2(i)*360.0)*(0.9+cut*0.95));
        lightness  = 0.09/d;
        float flicker = sin(iTime * 10.0 * myhash2(i))+1.5;
        col += vec3(0.01*sin(iTime+10.0), 0.02, 0.05*sin(iTime))*lightness*flicker;
    }
    fragColor = vec4(col, 1.0);
}