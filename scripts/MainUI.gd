extends Control

onready var mana_anim: AnimationPlayer = get_node("Mana/AnimationPlayer")
onready var health_bar: ProgressBar = get_node("Health")
onready var mana_bar: ProgressBar = get_node("Mana")

func set_mana(v: float):
	mana_bar.value = v

func set_health(v: float):
	health_bar.value = v

func not_enough_mana():
	mana_anim.seek(0)
	mana_anim.play("Low_Mana")
