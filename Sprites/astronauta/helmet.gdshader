//	Starfield shader by Brian Smith (steampunkdemon.itch.io)
//	MIT licence

shader_type canvas_item;
uniform bool active;
const vec2 texture_dimensions = vec2(1024.0, 600.0); // Resolution of texture in pixels.
const vec2 star_dimensions = vec2(20.0, 50.0); // Size of a star in pixels based on texture_dimensions. Stars will only render to a maximum height of texture_dimensions.y / stars for horizontally scrolling stars or width of texture_dimensions.x / stars for vertically scrolling stars.
const float stars = 200.0; // Number of stars (rows for horizontally scrolling stars, columns for vertically scrolling stars).
const vec3 star_color = vec3(1.0, 1.0, 1.0);
const float base_scroll_speed = 50.0; // The higher the value the slower the scroll. Must be larger than 0.0 and additional_scroll_speed.
const float additional_scroll_speed = 20.0; // The higher the value the faster the scroll. Must be larger than 0.0 but smaller than base_scroll_speed.
const float preprocess = base_scroll_speed * (base_scroll_speed - additional_scroll_speed) * 3.0; // Spreads out the stars so they cover the texture from the start.
//	For horizontally scrolling stars:
const vec2 adjusted_star_dimensions = vec2(1.0 / texture_dimensions.x * star_dimensions.x, 1.0 / texture_dimensions.y * star_dimensions.y * stars);
//	For vertically scrolling stars:
//	const vec2 adjusted_star_dimensions = vec2(1.0 / texture_dimensions.x * star_dimensions.x * stars, 1.0 / texture_dimensions.y * star_dimensions.y);

float greater_than(float x, float y) {
	
	return max(sign(x - y), 0.0);
	
}

void fragment() {
	vec4 curr_color = texture(TEXTURE,UV);
	if(curr_color.b >= 0.2 && curr_color.r <= 0.2){
		float random_value = fract(sin(dot(floor(UV * vec2(1.0, stars)), vec2(12.9898,78.233))) * 43758.5453123);
	
		COLOR.rgb = mix(vec3(0,0,0), star_color, random_value * greater_than(adjusted_star_dimensions.x, mod(UV.x + (preprocess + TIME) / (base_scroll_speed - random_value * additional_scroll_speed), 1.0)) * greater_than(adjusted_star_dimensions.y, fract(UV.y * stars)));
	}

}