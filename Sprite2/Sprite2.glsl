mat3 rotateY(float theta) { 
    float c = cos(theta);
    float s = sin(theta);
    return mat3(
        vec3(c, 0, s),
        vec3(0, 1, 0),
        vec3(-s, 0, c)
    );
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;

    vec3 rayOri = vec3(0.0, 0.0, -2.0);
    vec3 rayDir = normalize(vec3(uv, 1.0)); 

    float angle = iTime * 1.5; 
    mat3 rot = rotateY(angle);

    vec3 planeNormal = rot * vec3(0.0, 0.0, -1.0);
    vec3 planePos = vec3(0.0, 0.0, 0.0);

    //t = -(dot(n,q)+d)/dot(n,dir)
    //dot(normal,dir)
    float denom = dot(planeNormal, rayDir);
    vec3 col = vec3(0.1);

    if (abs(denom) > 0.0001) {
        // t = dot(pos - ori, normal) / dot(dir, normal)
        float t = (dot(planePos - rayOri, planeNormal)) / denom;
        
        if (t > 0.0) {
            vec3 intersectPos = rayOri + rayDir * t;
            
            vec3 localPos = intersectPos * rot;
            
            vec2 cardSize = vec2(0.4, 0.6);
            if (abs(localPos.x) < cardSize.x && abs(localPos.y) < cardSize.y) {

                vec2 cardUV = localPos.xy / (cardSize * 2.0) + 0.5;
                
                col = texture(iChannel0, cardUV).rgb;
                
                float lighting = max(dot(planeNormal, -rayDir), 0.3);
                col *= lighting;

                float border = smoothstep(0.45, 0.5, max(abs(cardUV.x-0.5), abs(cardUV.y-0.5)*0.66));
                col = mix(col, vec3(1.0, 0.8, 0.0), border);
            }
        }
    }
    fragColor = vec4(col, 1.0);
}