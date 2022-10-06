class_name CallFunc extends Behavior

var delay = 0
var initial_delay = 0

var can_cast := true
var internal_timer = 0

var method_name: String

func _init(method: String, del = 0, init_delay = 0) -> void:
	method_name = method
	delay = del
	initial_delay = init_delay

func act(delta: float, entityKnowledge: EntityKnowledge):
	internal_timer += delta
	if can_cast and internal_timer > initial_delay:
		if spatial.has_method(method_name):
			spatial.call(method_name)
		else:
			printerr("Entity does not have method ", method_name)
		can_cast = false
	if delay > 0 and internal_timer > delay:
		can_cast = true

func reset():
	internal_timer = 0
	can_cast = true
