float sdCircle(vec2 uv, vec2 pos, float radius)
{
    return length(uv - pos) - radius;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = (fragCoord - 0.5f * iResolution.xy) / iResolution.y;
    vec2 mousePos = (iMouse.xy - 0.5f * iResolution.xy) / iResolution.y;
    
    vec2 centerUv = fragCoord / iResolution.xy;
    //read the height from last frame and previous frame
    vec4 data = texture(iChannel0, centerUv);
    vec2 texel = 1.0 / iResolution.xy;
    float h_last = data.r;
    float h_prev = data.g;
    float damping =0.99;

    //read the height of four neighbors
    float h_up    = texture(iChannel0, centerUv + vec2(0, texel.y)).r;
    float h_down  = texture(iChannel0, centerUv - vec2(0, texel.y)).r;
    float h_left  = texture(iChannel0, centerUv - vec2(texel.x, 0)).r;
    float h_right = texture(iChannel0, centerUv + vec2(texel.x, 0)).r;
    
    float circle=0.0f;
    if(iMouse.z>0.0)
    {
        float circle = sdCircle(uv, mousePos, 0.02);
        h_last += 1.0f - step(0.0f, circle);
    }

    //Update the height based on wave equation and damping
    h_prev+=(-2.0f*h_last+h_left+h_right)*0.25f;
    h_prev+=(-2.0f*h_last+h_up+h_down)*0.25f;
    h_last+=h_prev;
    h_last*=damping;

    fragColor=vec4(h_last,h_prev,(h_left-h_right)*0.5,(h_up-h_down)*0.5);
}