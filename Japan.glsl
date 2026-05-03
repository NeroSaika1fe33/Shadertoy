float getWaveHeight(vec2 p) {
    float d = length(p);
    float w1 = sin(d * 15.0 - iTime * 3.0);
    float w2 = sin(p.x * 12.0 + p.y * 8.0 + iTime * 2.0);
    return (w1 * 0.5 + w2 * 0.5) * 0.5 + 0.5;
}

void mainImage(out vec4 fragColor,in vec2 fragCoord)
{
    vec2 uv =(fragCoord-0.5*iResolution.xy)/iResolution.y;
    float d= sqrt(uv.x*uv.x+uv.y*uv.y);

    float round=smoothstep(0.1,0.11,d);
    vec3 col=mix(vec3(1.0,0.0,0.0),vec3(1.0,1.0,1.0),round);
    fragColor=vec4(col,1.0);
    
    if(length(uv)>d){
    //波动方程
    //h=sin(k*d-ω*t),k是波的频率，ω是波的速度,ｈ是波的高度
    //衰减Attenuation：1/d
        //波动方程
    //h=sin(k*d-ω*t),k是波的频率，ω是波的速度,ｈ是波的高度
    //衰减Attenuation：1/d
    float ds=length(uv);
    float k=200.0;
    float w=20.0;
    float h=sin(k*ds-w*iTime);
    h*=exp(-ds*1.0);

    //vec3 n=normalize(abs(vec3(0.0f,0.0f,1.0f)+vec3(uv.x,uv.y,h)));

    float e = 0.1;
    float hx = getWaveHeight(uv + vec2(e, 0.0)) - h;
    float hy = getWaveHeight(uv + vec2(0.0, e)) - h;
    vec3 n = normalize(vec3(-hx, -hy, e));
    col +=mix(vec3(0.5,0.1,0.8),vec3(0.9,0.9,0.9),n);
    vec3 spec =vec3(0.2*pow((max(hx,hy*0.5)),8.0));
    fragColor=vec4(col+spec,1.0);
    }


}