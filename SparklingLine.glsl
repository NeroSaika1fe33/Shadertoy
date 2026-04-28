void mainImage (out vec4 fragColor,in vec2 fragCoord)
{
        vec2 uv =fragCoord/iResolution.xy;
        vec2 line=vec2(uv.x,fract(iTime*0.5));
        float d=length(uv-line);
        float brightness=0.008+0.001*sin(iTime*5.0);
        float spark=brightness/d;
  
    vec3 col = vec3(0.5 + 0.5 * sin(iTime), 0.3, 1.0);
    vec3 finalCol=vec3(0.0);
    finalCol += col * spark;
        fragColor=vec4(finalCol,1.0);
}