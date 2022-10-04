class_name Shimmy extends Behavior

var internal_timer = 0
var direction = random_direction()
var change_dir_time = 1
var speed = 1

func reset():
	internal_timer = 0

func _init(spd: float, dir_time: float):
	speed = spd
	change_dir_time = dir_time

func act(delta: float):
	internal_timer += delta 
	if internal_timer > change_dir_time:
		internal_timer = 0
		direction = random_direction()
	spatial.translate(direction * speed * delta)
		
func random_direction():
	return Vector3(randi() % 3 - 1, 0, randi() % 3 - 1).normalized()
