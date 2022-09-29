extends Spatial

export var max_health: float = 10
var health := max_health

func _on_Area_body_entered(body: Node) -> void:
	health -= 1
	print("ouch")
	body.queue_free()
	
func _process(delta: float) -> void:
	pass
