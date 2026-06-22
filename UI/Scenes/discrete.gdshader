shader_type sky;

uniform vec3 space_bg_color : source_color = vec3(0.005, 0.005, 0.015); // Dark space void
uniform float star_density : hint_range(0.01, 0.2) = 0.08;
uniform float twinkle_speed : hint_range(0.5, 5.0) = 2.5;

// Pure math pseudo-random cell hash
vec2 hash2(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
    return fract(sin(p) * 43758.5453123);
}

void sky() {
    // Set the base dark vacuum color of deep space
    COLOR = space_bg_color;
    
    // Project the 3D direction vector into a stable grid space for stars
    // Using xz/y or xy coordinates prevents pole stretching!
    vec2 sky_grid = EYEDIR.xy * 120.0; 
    if (EYEDIR.z < 0.0) {
        sky_grid = EYEDIR.xz * 120.0;
    }
    
    vec2 cell_id = floor(sky_grid);
    vec2 local_uv = fract(sky_grid);
    
    // Check cell ID to see if a star spawns here
    vec2 rand = hash2(cell_id);
    if (rand.x < star_density) {
        // Shift star slightly off-center inside its grid square for a natural look
        vec2 star_center = vec2(0.5) + (rand - 0.5) * 0.4;
        float dist = distance(local_uv, star_center);
        
        // Define star size (smaller looks sharper behind a UI)
        float star_radius = 0.03 + rand.y * 0.05;
        
        // Create soft emissive star glow
        float star_glow = smoothstep(star_radius, 0.0, dist);
        
        // Dynamic time-based twinkle calculation
        float twinkle = sin(TIME * twinkle_speed + rand.x * 20.0) * 0.5 + 0.5;
        
        // Tint individual stars slightly warm or cool based on random data
        vec3 star_color = mix(vec3(0.8, 0.9, 1.0), vec3(1.0, 0.9, 0.8), rand.y);
        
        // Inject stars onto skybox layer
        COLOR += star_glow * twinkle * star_color * 2.0;
    }
}