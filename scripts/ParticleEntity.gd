extends Particles

var handle: int

# Development steps:
# Make new Particles, Local coords required
# Convert to shader material
# load particle shader, shader params should already be populated

# Debugging steps:
# Make sure Visibility AABB is large enough to include the collider camera in it
# Make sure the particle has the right shader on it

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if visible:
		handle = EntityManager.registerParticleSpawner(self)
