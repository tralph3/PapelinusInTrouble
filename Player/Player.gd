extends CharacterBody2D

@export var ROTATION_SPEED = 2.0
@export var MAX_SPEED = 50.0
@export var FRICTION = 0.005
@export var ACCELERATION = 0.001
@export var BRAKE_FRICTION = 0.05

var current_speed = 0.0

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var rotation_direction = Input.get_axis("rotate_left", "rotate_right")
	rotation += rotation_direction * ROTATION_SPEED * delta
	var throttle = Input.get_axis("move_backwards", "move_forwards")
	var movement_direction = Vector2(cos(rotation - PI/2), sin(rotation - PI/2))
	if throttle:
		if throttle < 0 and MAX_SPEED > 0:
			MAX_SPEED *= -1
		elif throttle > 0 and MAX_SPEED < 0:
			MAX_SPEED *= -1
		current_speed = lerp(current_speed, MAX_SPEED, ACCELERATION)
	else:
		if Input.is_action_pressed("brake"):
			current_speed = lerp(current_speed, 0.0, BRAKE_FRICTION)
		else:
			current_speed = lerp(current_speed, 0.0, FRICTION)
	
	movement_direction *= current_speed

	move_and_collide(movement_direction)
