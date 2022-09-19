extends Spatial

export var speed: float = 10
export var health_bar_path: NodePath
export var mana_bar_path: NodePath
onready var health_bar: ProgressBar = get_node(health_bar_path)
onready var mana_bar: ProgressBar = get_node(mana_bar_path)

onready var camera = get_node("Camera")
onready var grav_scene := preload("res://Grav Projectile.tscn")

var grav_ball
var grav_out: bool = false

var health: float = 100
var mana: float = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	EntityManager.registerEntity(self)

func _process(delta):
	update_ui()
	movement(delta)
	mana_cost(delta)
	regen(delta)

func mana_cost(delta):
	if grav_out:
		mana -= delta * 10
	if mana < 0:
		retrieve_ball()
		mana = 0

func regen(delta):
	health = min(health + delta, 100)
	mana = min(mana + delta, 100) 

func particleCollisions(num: int):
	health -= num

func update_ui():
	health_bar.value = health
	mana_bar.value = mana

func movement(delta):
	var dir = Vector3()
	var inputMoveVector = Vector2()

	var aim = camera.transform.basis
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
	dir = dir.normalized() * speed * delta
	
	transform = transform.translated(dir)

func send_ball(target):
	grav_out = true
	grav_ball.target = target + Vector3(0, 0.5, 0)
	grav_ball.translation = translation
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
