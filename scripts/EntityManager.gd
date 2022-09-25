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
		
		i = 0
		if _gravityPoints.size() > 0:
			var grav_pos = _gravityPoints[0].translation
			var uniform = Rect2(grav_pos.x, grav_pos.y, grav_pos.z, _gravityPoints[0].strength)
			particleSpawner.process_material.set_shader_param("gravity_point", uniform)

# Registers an entity to the entity list
func registerParticleCollider(object: Node) -> int:
	_particleColliders[colliderCount] = object
	colliderCount += 1
	return colliderCount - 1

func registerParticleSpawner(object: Particles) -> int:
	_particleSpawner[particleCount] = object
	particleCount += 1
	updateViewportShaderParams(_vp_size, _sectors)
	return particleCount - 1

func registerGravityPoint(object: Object) -> int:
	_gravityPoints[gravCount] = object
	gravCount += 1
	return gravCount - 1

func particleCollisions(collision_data: Array):
	var i = 0
	for collider in _particleColliders.values():
		collider._collide(collision_data[i])
		i += 1


# Called from viewports to report pixels representing collision detections
func forwardParticleCollisions(index: int, todo_other_info: Object):
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	updateParticleUniforms()
