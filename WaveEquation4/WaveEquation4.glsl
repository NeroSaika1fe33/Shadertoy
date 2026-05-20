//Created base on https://www.shadertoy.com/view/4fSGRc
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord/iResolution.xy;
    
    vec3 wave = texture(iChannel0, uv).rab;
    wave.x = floor(wave.x*10.0);
    vec3 col = texture(iChannel1, uv + wave.yz * 0.05f).rgb;
    //vec3 col=vec3(1.0)+wave;
    // Output to screen
    fragColor = vec4(col, 1.0f);
}