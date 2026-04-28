void mainImage(out vec4 fragColor,in vec2 fragCoord)
{
    vec2 uv =(fragCoord-0.5*iResolution.xy)/iResolution.y;
    float radius=0.3;
    float d=length(uv);
    vec3 finalcol=vec3(0.0);
    float shininess=50.0;
    if(d<radius)
    {
        float z =sqrt(radius*radius-d*d);
        //法线
        vec3 n=normalize(vec3(uv,z));
        //指向光源的向量
        vec3 l=normalize(vec3(sin(iTime),0.5,0.5));
        //指向相机的向量
        vec3 v=normalize(vec3(0.0,0.0,1.0));
        //半程向量
        vec3 h=normalize(l+v);

        vec3 amb=vec3(0.0,0.1,0.15);
        float diff=max(dot(n,l),0.0);
        vec3 diffcol=vec3(0.0);
        if(diff>0.5)
            diffcol=vec3(0.0,0.6,0.6);
        else if(diff>0.1)
            diffcol=vec3(0.0,0.4,0.4);
        else
            diffcol=vec3(0.0,0.1,0.1);

        float spec=max(dot(n,h),0.0);
        vec3 speccol=vec3(1.0)*spec;
        if(spec>0.99)
            speccol=vec3(1.0);
        else if(spec>0.985)
            speccol=vec3(0.0,0.3,0.3);
        else
            speccol=vec3(0.0);
        
    finalcol+=amb+diffcol+speccol;
    }
fragColor=vec4(finalcol,1.0);
}