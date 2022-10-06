class_name MatchEvent extends Condition

var event_type

func _init(type: int):
	event_type = type

func evaluate(eevent, payload):
	return event_type == eevent
