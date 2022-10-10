extends Control

onready var mana_anim: AnimationPlayer = get_node("Mana/AnimationPlayer")
onready var health_bar: ProgressBar = get_node("Health")
onready var mana_bar: ProgressBar = get_node("Mana")
onready var game_over_screen: Control = get_node("Game Over")
onready var victory_screen: Control = get_node("Victory")
onready var victory_timer: Label = get_node("Victory/Label")

func _ready() -> void:
	GameState.connect("game_over", self, "game_over")
	GameState.connect("victory", self, "victory")

func set_mana(v: float):
	mana_bar.value = v

func set_health(v: float):
	health_bar.value = v

func not_enough_mana():
	mana_anim.seek(0)
	mana_anim.play("Low_Mana")

func game_over():
	game_over_screen.visible = true

func victory(time_taken):
	victory_timer.text = time_taken
	victory_screen.visible = true

func _on_Button_pressed() -> void:
	EntityManager.reset()
	GameState.reset()
	get_tree().reload_current_scene()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		EntityManager.reset()
		GameState.reset()
		get_tree().reload_current_scene()
	
