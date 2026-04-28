void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;

    vec2 glid=fract(uv*10.0);
    //拓展；为什么插值能通过两个向量乘法实现一个浮点数，这个浮点数却能精准的表示出线条的宽度呢？
    float line =smoothstep(0.02, 0.03, glid.x) * smoothstep(0.02, 0.03, glid.y);
    fragColor = mix(vec4(1.0), vec4(1.0, 0.0, 0.0, 1.0), clamp(line, 0.0, 1.0));
    //确认一个点，这个其实代表的是一个各自的左下角顶点，所以可以通过shader的floor归一化使这个点来确认这个顶点所在的靠右上的那个格子
    vec2 myPoint=vec2(5.0,5.0);
    vec2 myTile1=vec2(5.0,5.0);
    vec2 myTile2=myTile1-vec2(1.0,0.0);
    vec2 myTile3=myTile1-vec2(0.0,1.0);
    vec2 myTile4=myTile1-vec2(1.0,1.0);

    //点周围的四个格子绘出
        if(floor(uv.x*10.0)==myTile1.x && floor(uv.y*10.0)==myTile1.y)
    {
        fragColor=vec4(0.0, 0.0, 255.0, 1.0);
    }
            if(floor(uv.x*10.0)==myTile2.x && floor(uv.y*10.0)==myTile2.y)
    {
        fragColor=vec4(0.0, 0.0, 255.0, 1.0);
    }
            if(floor(uv.x*10.0)==myTile3.x && floor(uv.y*10.0)==myTile3.y)
    {
        fragColor=vec4(0.0, 0.0, 255.0, 1.0);
    }
            if(floor(uv.x*10.0)==myTile4.x && floor(uv.y*10.0)==myTile4.y)
    {
        fragColor=vec4(0.0, 0.0, 255.0, 1.0);
    }
    //myPoint绘出
        if(abs(uv.x*10.0-myPoint.x)<0.2 && abs(uv.y*10.0-myPoint.y)<0.2)
    {
        fragColor=vec4(0.0, 1.0, 0.0, 1.0);
    }
}