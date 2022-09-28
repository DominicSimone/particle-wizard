extends Viewport

# https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/particle_shader.html

# Concept behind particle collisions
# When a shader detects that a particle is near a collider
# -> move particle position to below ground at origin to be captured by viewport camera
# -> mark particle to be deleted next frame
# Viewport will render every frame
# Read texture every frame and check for pixels
# Can segment texture into sections to handle multiple (but limited) colliders

export var VP_SIZE: int = 8
export var sectors := Vector2(2, 2)
var x_sectors: int
var y_sectors: int
var x_sector_size: int
var y_sector_size: int
var data: Array

func _ready() -> void:
	assert(sectors.x == float(int(sectors.x)))
	assert(sectors.y == float(int(sectors.y)))
	assert(sectors <= Vector2(VP_SIZE, VP_SIZE))
	assert(sectors > Vector2(0, 0))
	# Make sure sectors divides the viewport evenly (i.e. 16 into 4, deny 16 into 5)
	assert(float(VP_SIZE) / sectors.x == VP_SIZE / int(sectors.x))
	assert(float(VP_SIZE) / sectors.y == VP_SIZE / int(sectors.y))

	EntityManager.updateViewportShaderParams(VP_SIZE, sectors)

	x_sectors = sectors.x
	y_sectors = sectors.y
	x_sector_size = VP_SIZE / sectors.x
	y_sector_size = VP_SIZE / sectors.y

	# Size our array correctly
	for sector_num in sectors.x * sectors.y:
		data.append(0)
	
	print("Collision sectors: ", data)

func getSector(x: int, y: int) -> int:
	return (y / y_sector_size) * y_sectors + x / x_sector_size

# TODO reading wrong sectors? some overlap between sectors? reading viewport not working as intended
# it almost seems like the particles arent exactly fitting into a single pixel
func readViewport() -> Array:
	var image = get_texture().get_data()
	var hits: int = 0
	var cur_sector: int = 0
	image.lock()
	for x in image.get_width():
		for y in image.get_height():
			if getSector(x, y) != cur_sector:
				data[cur_sector] = hits
				cur_sector = getSector(x, y)
				hits = 0
			var pixel = image.get_pixel(x, y)
			if pixel.a > 0:
				hits += 1
	data[getSector(image.get_width() - 1, image.get_height() - 1)] = hits
	image.unlock()

	return data

func _process(delta) -> void:
	EntityManager.particleCollisions(readViewport())
	
