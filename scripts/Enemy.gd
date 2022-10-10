class_name Enemy extends Spatial

export var max_health: float
export var ai: String = "green_gem"
export var color: Color = Color.green
onready var health := max_health
onready var shield_scene := preload("res://Shield.tscn")
var knowledge := EntityKnowledge.new()
var state: State
var active = false

func _ready() -> void:
	set_color(color)
	state = SMBuilder.get_state_machine(ai)
	state.on_entry(self)

func set_color(color: Color):
	$gem.get_active_material(0).albedo_color = color

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
	if active:
		knowledge.health_percent = health / max_health
		health -= 1
		change_state(EEvent.Types.ON_HIT, 1)
		body.queue_free()
		if health <= 0:
			GameState.enemy_death()
			call_deferred("queue_free")

func _on_shield_toggle(status: bool) -> void:
	change_state(EEvent.Types.SHIELD_TOGGLE, status)

func _on_player_detection(body) -> void:
	change_state(EEvent.Types.PLAYER_DETECTION, null)
	knowledge.known_target = true
	knowledge.target = body

func _on_shield_hit() -> void:
	change_state(EEvent.Types.SHIELD_HIT, null)

# Used in state machine calls
func add_shield():
	var shield = shield_scene.instance()
	add_child(shield)

func set_active():
	GameState.enemy_active()
	active = true
