float myhash1( float n ) { return fract(sin(n)*43758.5453); }
vec2  myhash2( vec2  p ) { p = vec2( dot(p,vec2(127.1,311.7)), dot(p,vec2(269.5,183.3)) ); return fract(sin(p)*43758.5453); }

// The parameter w controls the smoothness
vec4 voronoi( in vec2 x, float w ,float di)
{
    vec2 n = floor( x );
    vec2 f = fract( x );
	vec4 m = vec4( 8.0, 0.0, 0.0, 0.0 );
    for( int j=-2; j<=2; j++ )
    for( int i=-2; i<=2; i++ )
    {
        vec2 g = vec2( float(i),float(j) );
        vec2 o = myhash2( n + g );	
		// animate
        o =0.5*sin( iTime + 6.2831*o );
        // distance to cell		
		float d = 1.2*length(g - f + o);
		
        // cell color
		vec3 col = 0.2*vec3(1,2,7)-0.2*vec3(1,0,0);
        // in linear space
        col = col;
        
        // do the smooth min for colors and distances		
		float h = smoothstep( -1.5, 0.3, (m.x-di*d)/w );
	    m.x   = mix( m.x,     d, h ) - h*(1.0-h)*w/(1.0+3.0*w); // distance
		m.yzw = mix( m.yzw, col, h ) + h*(1.0-h)*w/(1.0+3.0*w); // color
    }
	
	return m;
}

void mainImage(out vec4 fragColor,in vec2 fragCoord)
{
    vec2 uv = fragCoord/iResolution.xy;
    vec4 v1=voronoi(0.7*uv,0.5,0.2);
    vec4 v2=voronoi(0.2*uv,0.1,0.6);
    vec4 v3=voronoi(0.8*uv,0.6,0.7);
    vec4 v=0.5*(v1+v2+v3);

    vec3 col = sqrt(v.yzw);
    if ((col.g > 0.64) && (col.g < 0.655))
        col.rgb =vec3(1.0);
    else if (col.g >= 0.655) 
        col.rgb = 1.45*vec3( 0.239, 0.714, 0.984); 
    fragColor = vec4(col, 1.0);
}