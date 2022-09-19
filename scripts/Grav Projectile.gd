extends Spatial

export var strength = 100 setget ,get_strength
export var travel_speed = 8;
export var travel_curve: Curve
export var travel_ramp_time: float = 1.0
var target: Vector3 setget set_target
var travelling: bool = true setget set_travel
var travel_time: float = 0
var EM_handle: int

onready var particles = get_node("Gravity Particles")
onready var haze = get_node("Haze")

func set_target(t: Vector3):
	target = t
	set_travel(true)

func set_travel(b: bool):
	travelling = b
	travel_time = 0
	particles.visible = !b
	haze.visible = !b

func get_strength():
	if travelling or not visible:
		return 0
	else:
		return strength

func _ready() -> void:
	EM_handle = EntityManager.registerGravityPoint(self)

func _process(delta: float):
	if travelling:
		travel_time += delta
		var adj_speed = travel_curve.interpolate(min(1, travel_time / travel_ramp_time)) * travel_speed
		translation += (target - translation).normalized() * adj_speed * delta
		if (translation - target).length() < 0.1:
			set_travel(false)
