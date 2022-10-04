class_name Shimmy extends Behavior

var internal_timer = 0

func act(delta: float):
	internal_timer += delta * 2
	var sin_movement = sin(internal_timer) / 20
	var cos_movement = cos(internal_timer) / 20
	spatial.translate(Vector3(sin_movement, 0, cos_movement))
