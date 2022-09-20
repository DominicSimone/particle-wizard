extends KinematicBody

export var speed: float = 10
export var lifetime: float = 5
var target_dir: Vector3

func set_target(t: Vector3):
	target_dir = (t - translation).normalized()

func _physics_process(delta: float) -> void:
	move_and_collide(target_dir * speed * delta)
	lifetime -= delta
	if lifetime < 0:
		call_deferred("queue_free")
