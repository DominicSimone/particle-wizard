class_name ParticleCollider extends Spatial

signal hit(info)
export var size: float = 1
var enabled: bool = true
var handle: int

func _collide(info):
	emit_signal("hit", info)

func to_uniform() -> Rect2:
	var p = to_global(translation)
	return Rect2(p.x, p.y, p.z, size if enabled else 0)

func _ready() -> void:
	handle = EntityManager.registerParticleCollider(self)

func _exit_tree() -> void:
	EntityManager.deregisterParticleCollider(handle)
