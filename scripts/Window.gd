extends Node

var window_size: Vector2

func _ready():
	window_size = OS.window_size

func _input(event): 
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("fullscreen_toggle"):
		OS.window_fullscreen = !OS.window_fullscreen
		OS.window_borderless = !OS.window_borderless
		if !OS.window_fullscreen:
			OS.window_size = window_size
	
