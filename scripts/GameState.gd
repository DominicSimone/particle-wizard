extends Node

signal game_over
signal victory(time)

enum State {
	READY,
	ONGOING,
	VICTORY,
	GAME_OVER
}

var game_start_unix: int

var enemies_killed: int 
var player_alive: bool
var game_state: int

func _ready() -> void:
	reset()

func enemy_death():
	enemies_killed += 1
	sm()

func enemy_active():
	if game_state == State.READY:
		game_start_unix = Time.get_unix_time_from_system()
		game_state = State.ONGOING

func player_death():
	player_alive = false
	sm()

func sm():
	match game_state:
		State.ONGOING:
			if enemies_killed >= 3:
				game_state = State.VICTORY
				sm()
			if not player_alive:
				game_state = State.GAME_OVER
				sm()
		State.VICTORY:
			var total_time = Time.get_unix_time_from_system() - game_start_unix
			emit_signal("victory", Time.get_time_string_from_unix_time(total_time))
		State.GAME_OVER:
			emit_signal("game_over")

func reset():
	game_state = State.READY
	enemies_killed = 0
	player_alive = true
	game_start_unix = 0
