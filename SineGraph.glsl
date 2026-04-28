void mainImage(out vec4 fragColor,in vec2 fragCoord)
{
    vec2 p= (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    vec3 color=vec3(0.1);
    float x=smoothstep(0.01,0.0,abs(p.y));
    float y=smoothstep(0.01,0.0,abs(p.x));
    color=mix(color,vec3(1.0,0.0,0.0),x);
    color=mix(color,vec3(1.0,0.0,0.0),y);
    float sinValue1=smoothstep(0.01,0.0,abs(p.y-0.1*sin(p.x*10.0+iTime)));
    color=mix(color,vec3(0.0,0.0,1.0),sinValue1);
    float sinValue2=smoothstep(0.01,0.0,abs(p.y-0.2*sin((p.x-10.0)*20.0+iTime*10.0*2.0)));
    color=mix(color,vec3(0.0,1.0,1.0),sinValue2);
    float sinValue3=smoothstep(0.01,0.0,abs(p.y-0.3*sin((p.x-15.0)*30.0+iTime*5.0*3.0)));
    color=mix(color,vec3(0.5,1.0,0.0),sinValue3);
    float sinValue4=smoothstep(0.01,0.0,abs(p.x-0.1*sin(p.y*30.0+iTime)));
    color=mix(color,vec3(0.5,1.0,0.5),sinValue4);
    float sinValue5=smoothstep(0.01,0.0,abs(p.x-0.2*sin((p.y-10.0)*20.0+iTime*10.0*2.0)));
    color=mix(color,vec3(0.0,1.0,0.5),sinValue5);
    float sinValue6=smoothstep(0.01,0.0,abs(p.x-0.3*sin((p.y-15.0)*30.0+iTime*5.0*3.0)));
    color=mix(color,vec3(0.5,0.5,0.5),sinValue6);
    //vec3 blackcolor=vec3(mix(1.0,0.0,clamp(x+y+sinValue1+sinValue2+sinValue3+sinValue4+sinValue5+sinValue6,0.0,0.5)));
    fragColor=vec4(color,1.0);
}