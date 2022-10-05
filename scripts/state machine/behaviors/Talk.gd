class_name Talk extends Behavior

var talked: bool = false
var texts := ["Hello"]

func _init(t: Array) -> void:
	texts = t
	
func act(delta: float, entityKnowledge: EntityKnowledge): 
	if not talked:
		print(Util.rand_array(texts))
		talked = true

func reset():
	talked = false
