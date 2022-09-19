extends Camera

export var speed: float = 1

onready var player: Spatial = get_parent()
onready var grav_scene := preload("res://Grav Projectile.tscn")

var grav_ball
var grav_out: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	EntityManager.registerEntity(get_parent())

func _process(delta):
	var dir = Vector3()
	var inputMoveVector = Vector2()

	var aim = transform.basis
	if Input.is_action_pressed("move_forward"):
		inputMoveVector.y += 1
	if Input.is_action_pressed("move_backward"):
		inputMoveVector.y -= 1
	if Input.is_action_pressed("move_left"):
		inputMoveVector.x -= 1
	if Input.is_action_pressed("move_right"):
		inputMoveVector.x += 1

	inputMoveVector = inputMoveVector.normalized()
	dir += -aim.z * inputMoveVector.y
	dir += aim.x * inputMoveVector.x
	dir.y = 0
	dir = dir.normalized() * speed
	
	player.transform = player.transform.translated(dir)

func send_ball(target):
	grav_out = true
	grav_ball.target = target + Vector3(0, 0.5, 0)
	grav_ball.translation = player.translation
	grav_ball.visible = true

func retrieve_ball():
	grav_out = false
	grav_ball.visible = false

func _on_StaticBody_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			if grav_ball == null:
				grav_ball = grav_scene.instance()
				get_tree().root.add_child(grav_ball)
			if grav_out:
				retrieve_ball()
			else:
				send_ball(position)
