class_name State

var name:= "Unnamed"
var behaviors: Array = []
var transitions: Array = []
var dirty := false

func _init(b: Array, t: Array):
	behaviors = b
	transitions = t

func evaluate(e_event, payload):
	for transition in transitions:
		if transition.evaluate(e_event, payload):
			print("Transitioning to ", transition.to_state.name)
			return transition.to_state
	return null

func on_entry(spatial: Spatial):
	if dirty:
		reset()
	# Somewhat of a hack so behaviors can directly control the entity and have position access
	for behavior in behaviors:
		behavior.set_spatial(spatial)
	dirty = true

func on_exit():
	pass

func reset():
	for behavior in behaviors:
		behavior.reset()
	for transition in transitions:
		transition.reset()

# TODO Should also include a 'EntityKnowledge' data payload as well 
func act(delta: float):
	for behavior in behaviors:
		behavior.act(delta)
