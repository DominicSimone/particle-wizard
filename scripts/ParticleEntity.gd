extends Particles

var handle: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	handle = EntityManager.registerParticleSpawner(self)
