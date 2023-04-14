extends RigidBody2D
class_name Proyectil

func _init(direction: Vector2, force: float):
	assert(direction.is_normalized(), "Vector must be normalized, got: %s" % direction)
	look_at(direction)
	var impulse_vector = direction * force
	apply_impulse(impulse_vector)

