extends Node

var _entities := {}
var _particleSpawner := {}
var _gravityPoints := {}
var entityCount := 0
var particleCount := 0
var gravCount := 0

func updateParticleUniforms():
	for particleSpawner in _particleSpawner.values():
		if _entities.size() > 0:
			var player_pos = _entities[0].translation
			var collider = Rect2(player_pos.x, player_pos.y, player_pos.z, 1)
			particleSpawner.process_material.set_shader_param("player_collider", collider)
		
		if _gravityPoints.size() > 0:
			var grav_pos = _gravityPoints[0].translation
			var uniform = Rect2(grav_pos.x, grav_pos.y, grav_pos.z, _gravityPoints[0].strength)
			particleSpawner.process_material.set_shader_param("gravity_point", uniform)

# Registers an entity to the entity list
func registerEntity(object: Object) -> int:
	_entities[entityCount] = object
	entityCount += 1
	return entityCount - 1

func registerParticleSpawner(object: Particles) -> int:
	_particleSpawner[particleCount] = object
	particleCount += 1
	return particleCount - 1

func registerGravityPoint(object: Object) -> int:
	_gravityPoints[gravCount] = object
	gravCount += 1
	return gravCount - 1

func particleCollisions(number: int):
	pass

# Called from viewports to report pixels representing collision detections
func forwardParticleCollisions(index: int, todo_other_info: Object):
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	updateParticleUniforms()
