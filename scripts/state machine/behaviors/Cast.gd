class_name Cast extends Behavior

var spell_scene: PackedScene
var delay = 0
var initial_delay = 0

var can_cast := true
var internal_timer = 0

# A delay of 0 is a one-time cast.
func _init(scene: PackedScene, del = 0, init_delay = 0) -> void:
	spell_scene = scene
	initial_delay = init_delay
	delay = del

func act(delta):
	internal_timer += delta
	if can_cast and internal_timer > initial_delay:
		# TODO Get targeting information
		var spell = spell_scene.instance()
		spatial.get_tree().root.add_child(spell)
		spell.translation = spatial.translation
		spell.set_target(Vector3(0, 0, 0))
		
		print("Blam! Take this! I cast ", spell_scene)
		can_cast = false
	if delay > 0 and internal_timer > delay:
		can_cast = true

func reset():
	internal_timer = 0
	can_cast = true
