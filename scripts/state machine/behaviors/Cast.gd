class_name Cast extends Behavior

var spell_scene: PackedScene
var delay = 0
var initial_delay = 0
var targeted := true
	
var can_cast := true
var internal_timer = 0

# A delay of 0 is a one-time cast.
func _init(scene: PackedScene, del = 0, init_delay = 0, target: bool = true) -> void:
	spell_scene = scene
	initial_delay = init_delay
	delay = del
	targeted = target

func act(delta: float, entityKnowledge: EntityKnowledge):
	internal_timer += delta
	if can_cast and internal_timer > initial_delay:

		var spell = spell_scene.instance()
		spatial.get_parent().add_child(spell)
		
		if targeted and entityKnowledge.known_target:
			var cast_point = spatial.translation + \
				(entityKnowledge.target.translation - spatial.translation).normalized() * 2.5
			spell.translation = cast_point
			spell.look_at(entityKnowledge.target.translation, Vector3(0, 1, 0))
		else:
			spell.translation = spatial.translation
		
		can_cast = false
	if delay > 0 and internal_timer > delay:
		can_cast = true

func reset():
	internal_timer = 0
	can_cast = true
