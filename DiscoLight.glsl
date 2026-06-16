//noise background
vec3 bgColor = vec3(0.01, 0.16, 0.42);
const float noiseIntensity = 2.8;
const float noiseDefinition = 0.6;
const vec2 glowPos = vec2(-2., 0.);

float random(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float noise( in vec2 p )
{
    p*=noiseIntensity;
    vec2 i = floor( p );
    vec2 f = fract( p );
	vec2 u = f*f*(3.0-2.0*f);
    return mix( mix( random( i + vec2(0.0,0.0) ), 
                     random( i + vec2(1.0,0.0) ), u.x),
                mix( random( i + vec2(0.0,1.0) ), 
                     random( i + vec2(1.0,1.0) ), u.x), u.y);
}

float fbm( in vec2 uv )
{	
	uv *= 5.0;
    mat2 m = mat2( 1.6,  1.2, -1.2,  1.6 );
    float f  = 0.5000*noise( uv ); uv = m*uv;
    f += 0.2500*noise( uv ); uv = m*uv;
    f += 0.1250*noise( uv ); uv = m*uv;
    f += 0.0625*noise( uv ); uv = m*uv;
    
	f = 0.5 + 0.5*f;
    return f;
}

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
    vec2 uv = (fragCoord-0.5*iResolution.xy) / iResolution.y;
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
        //d = length(uv-line*rotator*rot(myhash2(i)*360.0));

        lightness  = 0.09/(d*fbm(uv*1.5+vec2(3.0)));
        //lightness  = 0.09/(d);

        float flicker = sin(iTime * 10.0 * myhash2(i))+1.5;
        col += vec3(0.01*sin(iTime+10.0), 0.02, 0.05*sin(iTime))*lightness*flicker;
    }
    fragColor = vec4(col, 1.0);
}