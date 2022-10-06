extends Area

signal player_detected

func _ready() -> void:
	if get_parent().has_method("_on_player_detection"):
		connect("player_detected", get_parent(), "_on_player_detection")
	else:
		print("Parent does not have a detector handler")

func _on_Area_body_entered(body: Node) -> void:
	emit_signal("player_detected")
