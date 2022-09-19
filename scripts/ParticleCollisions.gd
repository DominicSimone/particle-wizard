extends Viewport

# https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/particle_shader.html

# Concept behind particle collisions
# When a shader detects that a particle is near a collider
# -> set particle color to 1.0 / 255.0,..,.. (maybe low alpha?)
# -> move particle position to below ground at origin to be captured by viewport camera
# -> mark particle to be deleted next frame
# Viewport will render every frame
# Read texture every frame and check color of pixels
# Check color for # of collisions with colliders
# Can segment texture into sections to handle multiple (but limited) colliders

func readViewport() -> int:
	var image = get_texture().get_data()
	var hits: int = 0
	image.lock()
	for x in image.get_width():
		for y in image.get_height():
			var pixel = image.get_pixel(x, y)
			if pixel.a > 0:
				hits += 1
	image.unlock()
	return hits

func _process(delta) -> void:
	EntityManager.particleCollisions(readViewport())
	
