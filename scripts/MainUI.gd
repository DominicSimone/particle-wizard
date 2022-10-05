extends Control

onready var mana_anim: AnimationPlayer = get_node("Mana/AnimationPlayer")
onready var health_bar: ProgressBar = get_node("Health")
onready var mana_bar: ProgressBar = get_node("Mana")
onready var game_over_screen: Control = get_node("Game Over")

func set_mana(v: float):
	mana_bar.value = v

func set_health(v: float):
	health_bar.value = v

func not_enough_mana():
	mana_anim.seek(0)
	mana_anim.play("Low_Mana")

func game_over():
	game_over_screen.visible = true

func _on_Button_pressed() -> void:
	EntityManager.reset()
	get_tree().reload_current_scene()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		EntityManager.reset()
		get_tree().reload_current_scene()
	
