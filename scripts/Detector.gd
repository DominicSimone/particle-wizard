extends Area

signal player_detection

func _ready() -> void:
	Util.parent_hook(self, "player_detection")

func _on_Area_body_entered(body: Node) -> void:
	emit_signal("player_detection")
