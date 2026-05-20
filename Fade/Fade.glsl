void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord / iResolution.xy;
    float fadeRate =abs(sin(iTime));
    vec4 t1 = texture(iChannel0, uv);
    vec4 t2 = texture(iChannel1, uv);
    float alpha = (t1.a + t2.a)/2.0 * fadeRate;
    fragColor = vec4(t1.rgb * alpha + t2.rgb * (1.0 - alpha), alpha);
}