#iChannel0 "file://assets//Grace.png"

void mainImage(out vec4 fragColor,in vec2 fragCoord)
{
    vec2 uv =(fragCoord-0.5*iResolution.xy)/iResolution.y;
    float radius=0.3;
    float d=length(uv);
    vec3 color=vec3(1.0);
    float shininess=50.0;
    if(d<radius)
    {
        float z = sqrt(radius*radius-d*d);
        //法线
        vec3 n=normalize(vec3(uv,z));
        //指向光源的向量
        vec3 l=normalize(vec3(sin(iTime),1.0,cos(iTime)));
        //指向相机的向量
        vec3 v=normalize(vec3(0.0,0.0,1.0));
        //半程向量
        vec3 h=normalize(l+v);
        vec3 amb=vec3(0.3,0.0,0.0);
        float diff=max(dot(n,l),0.0);
        vec3 diffcol=vec3(1.0,0.3,0.3)*diff;
        float spec=0.0;
        if(l.z>=-0.5){
        spec=pow(max(dot(n,h),0.0),shininess);
        }
        color=amb+spec+diffcol*texture(iChannel0,(n.xy*0.4+0.5)).rgb;
    }
    //伽马校正 +(uv*0.9+vec2(0.55,0.48))
    color = pow(color, vec3(1.0/2.2));
    fragColor=vec4(color,1.0);
}