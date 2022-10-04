class_name Transition

var to_state: State
var conditions: Array = []

func _init(state: State, conditions_list: Array):
	to_state = state
	conditions = conditions_list

func reset():
	for condition in conditions:
		condition.reset()

func evaluate(e_event, payload) -> bool:
	for condition in conditions:
		if condition.evaluate(e_event, payload):
			return true
	return false
