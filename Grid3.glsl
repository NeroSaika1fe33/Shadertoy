void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-0.5*iResolution.xy)/iResolution.y;
    //back
    vec2 uv2 = uv * 80.0;
    uv2 = abs(fract(uv2)-0.5);
    vec4 bgColor = (uv2.x > 0.4 || uv2.y > 0.4) ? vec4(0.1,0.15,0.25,1.0) : vec4(0.1,0.2,0.35,1.0);
    fragColor = bgColor;

    uv *=mat2(1.1,-1.1,-1.1,-1.1)/sqrt(2.);
    vec2 pos= 30.0*uv;
    vec2 rep = fract(pos+vec2(0.5));
    float dist = 1.0 - 2.0*min(min(rep.x,1.0-rep.x),min(rep.y,1.0-rep.y));
    dist = pow(dist,2.0);

    vec2 blockNum = floor(pos + vec2(0.5));
    float squareDist = length(blockNum);
    //Position set by pow
    float style = 0.6;   //can use this to change the style;
    float edge = pow(sin(0.5*iTime-squareDist*style + (blockNum.x-blockNum.y)*0.005),0.4);

    float aSide = smoothstep(edge-0.4,edge-0.1,1.2*dist)*2.0-1.0;
    float bSide = smoothstep(edge-0.5,edge-0.3,1.2*dist)*2.0-1.0;
    float value = clamp(aSide*bSide,0.0,1.0);
    fragColor = vec4(value);

    vec4 spRingColor =(mod(sqrt(blockNum.x*blockNum.x+blockNum.y*blockNum.y),5.0)<1.5)?vec4(0.2,0.05,0.6,1.0):vec4(0.9,0.9,0.9,1.0);
    vec4 ringColor = (mod(blockNum.x+blockNum.y,2.0)<0.01)?vec4(0.2,0.65,0.85,1.0):spRingColor;
    //vec4 ringColor =vec4(0.2,0.65,0.85,1.0); 

    fragColor=mix(ringColor,bgColor,value);
}