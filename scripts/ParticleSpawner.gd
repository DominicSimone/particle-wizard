class_name ParticleSpawner extends Particles

var handle: int
var free_delay_timer := lifetime

# Development steps:
# Make new Particles, make it look nice
#  - sphere emission shape
#  - local coords required
#  - one shot
#  - layers 1 and 2
# Convert to shader material
# load particle shader, shader params should already be populated

# Debugging steps:
# Make sure Visibility AABB is large enough to include the collider camera in it
# Make sure the particle has the right shader on it

func _ready() -> void:
	handle = EntityManager.registerParticleSpawner(self)
	emitting = true

func _process(delta: float) -> void:
	if not emitting:
		free_delay_timer -= delta
		if free_delay_timer <= 0:
			call_deferred("queue_free")

func _exit_tree() -> void:
	EntityManager.deregisterParticleSpawner(handle)
