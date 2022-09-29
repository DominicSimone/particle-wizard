extends StaticBody

export var max_health: float 
export var regen_cd: float 
export var regen_rate: float 
onready var anim := $AnimationPlayer
onready var particle_collider := $ParticleCollider
onready var health: float = max_health
var regen_timer: float = 0
var old_layer_mask = collision_layer
var old_collision_mask = collision_mask

func _process(delta: float) -> void:
	regen_timer += delta
	if regen_timer > regen_cd:
		health = min(max_health, health + regen_rate * delta)
		if health > 1 and not visible:
			enable()

func _on_ParticleCollider_hit(info) -> void:
	if health > 0:
		anim.stop()
		anim.play("Hit")
		health -= 1
		regen_timer = 0
		if health <= 0:
			disable()

func enable():
	visible = true
	particle_collider.enabled = true
	collision_layer = old_layer_mask
	collision_mask = old_collision_mask

func disable():
	visible = false
	particle_collider.enabled = false
	old_layer_mask = collision_layer
	old_collision_mask = collision_mask
	collision_layer = 0
	collision_mask = 0
