extends RigidBody2D

var FORCE = 300.0

func init(death_point):
	var direction_vector = position.direction_to(death_point)
	print("Direction: %s" % direction_vector)
	apply_impulse(direction_vector * FORCE)

