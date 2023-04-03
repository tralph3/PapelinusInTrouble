extends CharacterBody2D

@export var ROTATION_SPEED = 2.0
@export var MAX_SPEED = 500.0
@export var FRICTION = 0.05
@export var ACCELERATION = 0.02
@export var BRAKE_FRICTION = 0.1
@export var MUNITION:  PackedScene = preload("res://Bullet/Bullet.tscn")

var current_speed = 0.0
var movement_direction = Vector2(cos(rotation - PI/2), sin(rotation - PI/2))
var can_shoot = true

func _physics_process(delta):
	handle_input(delta)

func handle_input(delta):
	handle_movement(delta)
	handle_shoot()

func handle_movement(delta):
	var rotation_direction = Input.get_axis("rotate_left", "rotate_right")
	var throttle = Input.get_axis("move_backwards", "move_forwards")

	rotation += rotation_direction * ROTATION_SPEED * delta
	movement_direction = Vector2(cos(rotation - PI/2), sin(rotation - PI/2))
	current_speed = apply_throttle(throttle)
	movement_direction *= current_speed * delta
	move_and_collide(movement_direction)

func handle_shoot():
	if Input.is_action_just_pressed("shoot") and can_shoot:
		$ShotCooldown.start()
		can_shoot = false
		shoot()

func apply_throttle(throttle):
	if throttle:
		if not (throttle * MAX_SPEED > 0):
			MAX_SPEED *= -1
		current_speed = lerp(current_speed, MAX_SPEED, ACCELERATION)
	elif Input.is_action_pressed("brake"):
		current_speed = lerp(current_speed, 0.0, BRAKE_FRICTION)
	else:
		current_speed = lerp(current_speed, 0.0, FRICTION)
	return current_speed

func reset_can_shoot():
	can_shoot = true
	
func shoot():
	if not MUNITION:
		return
	var shot = MUNITION.instantiate()
	shot.owner = get_parent()
	get_parent().add_child(shot)
	shot.position = $Uretra.global_position
	shot.rotation = global_rotation
