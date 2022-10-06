extends Node

var _particleColliders := {}
var _particleSpawner := {}
var _gravityPoints := {}
var colliderCount := 0
var particleCount := 0
var gravCount := 0

# For passing this info on to newly spawned particle colliders
var _vp_size: int
var _sectors: Vector2



func updateViewportShaderParams(vp_size: int, sectors: Vector2):
	_vp_size = vp_size
	_sectors = sectors
	for particleSpawner in _particleSpawner.values():
		particleSpawner.process_material.set_shader_param("vp_size", vp_size)
		particleSpawner.process_material.set_shader_param("sectors", sectors)

func updateParticleUniforms():
	for particleSpawner in _particleSpawner.values():
		var i = 0
		for collider in _particleColliders.values():
			var data = collider.to_uniform()
			var uniform_name = "particle_collider_" + String(i)
			particleSpawner.process_material.set_shader_param(uniform_name, data)
			i += 1
		
		# TODO convert to array format like particle colliders, add second entry in shader
		if _gravityPoints.size() > 0:
			var grav_pos = _gravityPoints[0].translation
			var uniform = Rect2(grav_pos.x, grav_pos.y, grav_pos.z, _gravityPoints[0].strength)
			particleSpawner.process_material.set_shader_param("gravity_point", uniform)

func registerParticleCollider(object: Node) -> int:
	print("Registered particle collider: ", object)
	_particleColliders[colliderCount] = object
	colliderCount += 1
	return colliderCount - 1

func deregisterParticleCollider(handle: int):
	_particleColliders.erase(handle)
	colliderCount -= 1

func registerParticleSpawner(object: Particles) -> int:
	print("Registered particle spawner: ", object)
	_particleSpawner[particleCount] = object
	particleCount += 1
	updateViewportShaderParams(_vp_size, _sectors)
	return particleCount - 1

func registerGravityPoint(object: Object) -> int:
	print("Registered gravity point: ", object)
	_gravityPoints[gravCount] = object
	gravCount += 1
	return gravCount - 1

func particleCollisions(collision_data: Array):
	var i = 0
	for collider in _particleColliders.values():
		var collision = collision_data[i]
		if collision > 0:
			collider._collide(collision)
		i += 1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	updateParticleUniforms()

func reset():
	print("Resetting entity manager...")
	# Need to reset shader params or they will carry over between restarts
	for particleSpawner in _particleSpawner.values():
		particleSpawner.process_material.set_shader_param("gravity_point", Rect2(0, 0, 0, 0))
		for i in 4:
			particleSpawner.process_material.set_shader_param("particle_collider_" + String(i), Rect2(0, 0, 0, 0))
	
	# Now can clear all entity information so we don't have dangling references, they will all be
	# re-registered in respective _ready functions
	_particleColliders = {}
	_particleSpawner = {}
	_gravityPoints = {}
	colliderCount = 0
	particleCount = 0
	gravCount = 0
