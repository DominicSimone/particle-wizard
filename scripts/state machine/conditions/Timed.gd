class_name Timed extends Condition

var init_time: float
var timeLeft: float

func _init(timer: float):
	init_time = timer
	timeLeft = timer

func reset():
	timeLeft = init_time

func evaluate(e_event, payload) -> bool:
	match e_event:
		EEvent.Types.TIME_DELTA:
			timeLeft -= payload
			if timeLeft < 0:
				return true
	return false
