void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;

    // Time varying pixel color
    vec3 ripplesDir = texture(iChannel0, uv).rab;
    //ripplesDir.x=floor(ripplesDir.x*5.0)/5.0;
    vec3 col = texture(iChannel1, uv).rgb;
    // vec3 col=vec3(1.0)+ripplesDir;
    // Output to screen
    fragColor = vec4(col, 1.0f);
}