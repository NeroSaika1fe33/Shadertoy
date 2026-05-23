//Voronoi Noise Algorithm is based on https://docs.unity3d.com/ja/Packages/com.unity.shadergraph@10.0/manual/Voronoi-Node.html
//Some kinds of Water Surface Effect
//But now cannot be correctly rendered when the distance of cells frequently changing sometimes.
vec2 voronoi_hash(vec2 p,float w)
{
    mat2 m =mat2(15.27,47.63,99.41,89.98);
    p = fract(sin(p*m)*46839.32);
    return vec2(sin(p.y*w)*0.5+0.5,cos(p.x*w)*0.5+0.5);
}

vec2 Unity_Voronoi_float(vec2 UV, float AngleOffset, float CellDensity)
{
    vec2 g = floor(UV * CellDensity);
    vec2 f = fract(UV * CellDensity);
    float t = 5.0;
    vec3 res = vec3(t, 0.0, 0.0);
    vec2 Out = vec2(0.0);

    for(int y=-1; y<=1; y++)
    {
        for(int x=-1; x<=1; x++)
        {
            vec2 lattice = vec2(x,y);
            vec2 offset = voronoi_hash(lattice + g, AngleOffset);
            float d = distance(lattice + offset, f);
            if(d < res.x )
            {   
                res = vec3(d, offset.x, offset.y);
                Out.x = res.x;
                Out.y = res.y;
            }
        }
    }
    return Out;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) 
{
    vec2 uv = fragCoord / iResolution.y;
    float flow = 10.0 + iTime * 0.8;
    float CellDesity = 5.0;
    vec2 v = Unity_Voronoi_float(uv, flow, CellDesity);
    
    //v.x is the distance to the nearest cell center
    //v.y is the cell ID (0 to 1)
    float dis = v.x;
    float cells = v.y;

    if(dis<0.01)
    {
        v=Unity_Voronoi_float(uv, flow/10.0, CellDesity);
    }

    float frame = smoothstep(1.0, 0.1, dis);
    vec3 waterBase = vec3(0.3, 0.2, 0.5);
    vec3 brightWater = vec3(0.2, 0.5, 1.0);
    vec3 col = vec3(0.0);
    col += texture(iChannel0,uv).rgb * 0.5;
    col += mix(waterBase, brightWater, cells * 1.0);

    col = mix(vec3(1.0), col, frame);

    fragColor = vec4(col, 1.0);
}