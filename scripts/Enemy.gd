extends Spatial

export var max_health: float
onready var health := max_health
var state: State

func _ready() -> void:
	state = SMBuilder.build({
		"start": [
			[Talk.new(["Greetings, cowards."])],
			{
				"shimmy": [Timed.new(1)]
			}
		],
		"shimmy": [
			[Shimmy.new()],
			{
				"stop_and_shoot": [Timed.new(10), RandomChance.new(0.1)]
			}
		],
		"stop_and_shoot": [
			[Cast.new(preload("res://PlayerShot.tscn"), 0, 1)],
			{
				"shimmy": [Timed.new(2)]
			}
		]
	})
	state.on_entry(self)

func _process(delta: float) -> void:
	state.act(delta)
	var next_state = state.evaluate(EEvent.Types.TIME_DELTA, delta)
	if next_state:
		state.on_exit()
		state = next_state
		state.on_entry(self)

func _on_Enemy_body_entered(body: Node) -> void:
	health -= 1
	body.queue_free()
