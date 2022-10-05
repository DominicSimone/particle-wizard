extends Spatial

export var max_health: float
export var ai: String = "debug_machine"
onready var health := max_health
var knowledge := EntityKnowledge.new()
var state: State

func _ready() -> void:
	state = SMBuilder.get_state_machine(ai)
	state.on_entry(self)

func change_state(type: int, payload):
	var next_state = state.evaluate(type, payload)
	if next_state:
		state.on_exit()
		state = next_state
		state.on_entry(self)

func _process(delta: float) -> void:
	state.act(delta, knowledge)
	change_state(EEvent.Types.TIME_DELTA, delta)

func _on_Enemy_body_entered(body: Node) -> void:
	knowledge.health_percent = health / max_health
	health -= 1
	change_state(EEvent.Types.ON_HIT, 1)
	body.queue_free()
