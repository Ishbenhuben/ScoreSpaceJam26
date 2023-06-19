shader_type canvas_item;

uniform vec3 paint_color : source_color;
uniform vec3 background_color : source_color;
uniform vec3 rand = vec3(12.9898, 78.233, 43758.5453123);

uniform float circle_size : hint_range(0.0, 1.0) = 0.0;

uniform float frequency = 3.0;
uniform float amplitude = 0.5;
uniform float intensity = 0.1;


float random(vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(rand.x,rand.y))) *
            rand.z);
}

float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    // Four corners in 2D of a tile
    float a = random(uv_index);
    float b = random(uv_index + vec2(1.0, 0.0));
    float c = random(uv_index + vec2(0.0, 1.0));
    float d = random(uv_index + vec2(1.0, 1.0));

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix(a, b, blur.x) +
            (c - a) * blur.y * (1.0 - blur.x) +
            (d - b) * blur.x * blur.y;
}

float fbm(vec2 uv) {
    int octaves = 6;
    float a = amplitude;
    float f = frequency;
	float value = 0.0;
	
    for(int i = 0; i < octaves; i++) {
        value += a * noise(frequency * uv);
        a *= 0.5;
        f *= 2.0;
    }
    return value;
}

void fragment(){
	float noise = fbm(UV);
	vec4 color = texture(TEXTURE, UV);
	color.rgb = mix(vec3(noise) * paint_color, background_color, intensity);
	//color.a *= 0.5;
	COLOR = color;
	COLOR.a *=  (color.r + color.g + color.b)/3.0 ;
	
	

	if (distance(UV, vec2(0.5,0.5)) > circle_size) 
	{
		COLOR.a *= 0.0;
	}

	
}
