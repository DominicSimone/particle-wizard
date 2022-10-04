class_name NOf extends Condition

var conditions_list := []
var n: int

func _init(num: int, conditions: Array):
	conditions_list = conditions
	n = num

func reset():
	for condition in conditions_list:
		condition.reset()

func evaluate(e_event, payload) -> bool:
	var true_conditions = 0
	for condition in conditions_list:
		if condition.evaluate(e_event, payload):
			true_conditions += 1
	if true_conditions > n:
		return true
	return false
