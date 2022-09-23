extends Area

export var max_health: float = 3
export var regen_cd: float = 5
export var regen_rate: float = 0.5
onready var anim := $AnimationPlayer
var health: float = max_health
var regen_timer: float = 0

func _on_Shield_body_entered(body: Node) -> void:
	if health > 0:
		body.queue_free()
		anim.stop()
		anim.play("Hit")
		health -= 1
		regen_timer = 0
		if health <= 0:
			visible = false

func _process(delta: float) -> void:
	regen_timer += delta
	if regen_timer > regen_cd:
		health = min(max_health, health + regen_rate * delta)
		if health > 1 and not visible:
			visible = true
