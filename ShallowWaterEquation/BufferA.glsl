#define PI 3.1417

#define SIZE 256.0
#define RIPPLES_STRENGTH 10.0
#define RIPPLES_INTENSITY 1.0 //<1, 100>

#define DENSITY 12.0

vec2 randomPos(vec2 uv)
{
    float angle = fract(sin(dot(uv, vec2(19.42343, 25.341245f))) * 42311.71234f);
    
    return vec2(cos(angle) * 0.5f, sin(angle)) * 0.5f + 0.5f;
}

float damping = 0.99f;

float sdCircle(vec2 uv, vec2 pos, float radius)
{
    return length(uv - pos) - radius;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord - 0.5f * iResolution.xy) / iResolution.y;
    vec2 mousePos = (iMouse.xy - 0.5f * iResolution.xy) / iResolution.y;
    
    vec2 id = floor(uv * SIZE);
    
    vec2 centerUv = fragCoord / iResolution.xy;
    float value = texture(iChannel0, centerUv).r;
    float prevValue = texture(iChannel0, centerUv).g;
    
    vec2 leftUv = (fragCoord - vec2(1.0f, 0.0f)) / iResolution.xy;
    vec2 rightUv = (fragCoord + vec2(1.0f, 0.0f)) / iResolution.xy;
    vec2 upUv = (fragCoord + vec2(0.0f, 1.0f)) / iResolution.xy;
    vec2 downUv = (fragCoord - vec2(0.0f, 1.0f)) / iResolution.xy;
    
    float left = texture(iChannel0, leftUv).r;
    float right = texture(iChannel0, rightUv).r;
    float up = texture(iChannel0, upUv).r;
    float down = texture(iChannel0, downUv).r;
    
    float circle = 0.0f;
    if(iMouse.z > 0.0f)
    {
        float circle = sdCircle(uv, mousePos, 0.02f);
        value += 1.0f - step(0.0f, circle);
    }

    vec2 fuv = fract(uv * SIZE);
    vec2 rndPos = randomPos(fuv + iTime);
    vec2 chooseOneRndPos = randomPos(id + iTime);
    float ripplesIntensityFactor = (mod(iTime, 50.0f) + 5.0f) * 0.001f;

    if(distance(chooseOneRndPos, rndPos) <= 0.0f)
    {
        circle = sdCircle(fuv, chooseOneRndPos, ripplesIntensityFactor);
        value += (1.0f - step(0.0f, circle)) * RIPPLES_STRENGTH;
    }

    prevValue += (-2.0f * value + right + left) * 0.25f;
    prevValue += (-2.0f * value + up + down) * 0.25f;
    value += prevValue;
    value *= damping;

    fragColor = vec4(value, prevValue, (right - left) / 2.0f, (up - down) / 2.0f);
}