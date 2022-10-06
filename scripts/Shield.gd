class_name Shield extends StaticBody

export var max_health: float 
export var regen_cd: float 
export var regen_rate: float 
onready var anim := $AnimationPlayer
onready var particle_collider := $ParticleCollider
onready var health: float = max_health
var regen_timer: float = 0
var old_layer_mask = collision_layer
var old_collision_mask = collision_mask

signal shield_toggle(status)

func _ready() -> void:
	if get_parent().has_method("_on_shield_toggle"):
		connect("shield_toggle", get_parent(), "_on_shield_toggle")
	else:
		print("Parent does not have a shield handler")

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
	emit_signal("shield_toggle", true)
	visible = true
	particle_collider.enabled = true
	collision_layer = old_layer_mask
	collision_mask = old_collision_mask

func disable():
	emit_signal("shield_toggle", false)
	visible = false
	particle_collider.enabled = false
	collision_layer = 0
	collision_mask = 0
