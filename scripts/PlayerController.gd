extends Spatial

export var speed: float = 10
export var ui_path: NodePath
export var rotate_speed: float = 2.0
onready var ui: Control = get_node(ui_path)

onready var camera = get_node("Camera")
onready var grav_scene := preload("res://Grav Projectile.tscn")
onready var shot_scene := preload("res://PlayerShot.tscn")

var grav_ball
var grav_out: bool = false
var grav_cost: float = 1
var shot_cost: float = 2

var health: float = 100
var mana: float = 100
var mana_recycle_ratio: float = 0.25

var alive := true

func _process(delta):
	if health < 0:
		if alive:
			GameState.player_death()
		alive = false
		set_process(false)
		return
	update_ui()
	movement(delta)
	mana_cost(delta)
	regen(delta)

func mana_cost(delta):
	if grav_out:
		mana -= delta * grav_cost
	if mana < 0:
		retrieve_ball()
		mana = 0

func regen(delta):
	health = min(health + delta, 100)
	mana = min(mana + delta, 100) 

func update_ui():
	ui.set_health(health)
	ui.set_mana(mana)


func movement(delta):
	var camera_rotation_direction = Input.get_action_strength("rotate_left") - Input.get_action_strength("rotate_right")
	var camera_rotation = camera_rotation_direction * delta * rotate_speed
	camera.global_translation = global_translation + (camera.global_translation - global_translation).rotated(Vector3.UP, camera_rotation)
	camera.look_at(global_translation, Vector3.UP)
	var aim = camera.transform.basis
	
	var inputMoveVector = Vector2()
	inputMoveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	inputMoveVector.y = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	inputMoveVector = inputMoveVector.normalized()
	
	var dir = -aim.z * inputMoveVector.y
	dir += aim.x * inputMoveVector.x
	dir.y = 0
	dir = dir.normalized() * speed * delta
	
	transform = transform.translated(dir)

func cast_grav(target):
	if grav_ball == null:
		grav_ball = grav_scene.instance()
		get_parent().add_child(grav_ball)
	if grav_out:
		retrieve_ball()
	else:
		send_ball(target)

func cast_shot(target):
	if mana > shot_cost:
		mana -= shot_cost
		var new_shot = shot_scene.instance()
		get_parent().add_child(new_shot)
		# Hack y offset as enemy is off the ground so their shield doesn't deplete
		# on lingering ground particles
		new_shot.translation = translation + Vector3(0, 2, 0)
		new_shot.set_target(target + Vector3(0, 2, 0))
	else:
		ui.not_enough_mana()

func send_ball(target):
	grav_out = true
	grav_ball.target = target + Vector3(0, 1, 0)
	grav_ball.translation = translation
	grav_ball.visible = true

func retrieve_ball():
	grav_out = false
	grav_ball.visible = false

func _on_StaticBody_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if alive and event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == BUTTON_RIGHT:
				cast_grav(position)
			if event.button_index == BUTTON_LEFT:
				cast_shot(position)

func _on_ParticleCollider_hit(info) -> void:
	health -= info
	mana += info * mana_recycle_ratio
	update_ui()
