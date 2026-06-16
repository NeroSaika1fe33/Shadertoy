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

vec3 bg(vec2 uv )
{
    float velocity = iTime/1.6;
    float intensity = sin(uv.x*3.+velocity*2.)*1.1+1.5;
    uv.y -= 2.;
    //v *= noiseDefinition;

    //ripple
    float rb = fbm(vec2(uv.x*.5-velocity*.03, uv.y))*.1;
    rb = sqrt(rb); 
    uv += rb;

    //coloring
    float rz = fbm(uv*.9+vec2(velocity*.35, .35));

    vec2 bp = uv+glowPos;
    rz *= dot(bp,bp);
    rz *= (10.*sin(uv.x*.5+velocity*.8));

    vec3 col = bgColor/(rz);
    return sqrt(abs(col));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord.xy-0.5*iResolution.y)/iResolution.xy;
    fragColor = vec4(bg(uv), 1.0);
}