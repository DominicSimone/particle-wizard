class_name RandomChance extends Condition

var chancePerSecond

func _init(prob: float):
	chancePerSecond = prob

func evaluate(e_event, payload) -> bool:
	match e_event:
		EEvent.Types.TIME_DELTA:
			if randf() < chancePerSecond * payload:
				return true
	return false
