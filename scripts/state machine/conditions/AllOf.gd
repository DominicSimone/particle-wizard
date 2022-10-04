class_name AllOf extends Condition

var conditions_list := []

func _init(conditions: Array):
	conditions_list = conditions

func reset():
	for condition in conditions_list:
		condition.reset()

func evaluate(e_event, payload) -> bool:
	for condition in conditions_list:
		if not condition.evaluate(e_event, payload):
			return false
	return true
