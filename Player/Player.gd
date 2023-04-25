extends RigidBody2D

@export var max_velocity = 500.0
@export var thrust = Vector2(0, 500)
@export var torque = 2000.0
@export var MUNITION:  PackedScene = preload("res://Bullet/Bullet.tscn")

var can_shoot = true
var dead = false

signal died

func _integrate_forces(state):
	var delta = state.step
	if not dead:
		handle_input(delta, state)
	else:
		state.set_linear_velocity(Vector2.ZERO)
		state.set_angular_velocity(0.0)
	
func handle_input(delta, state):
	handle_movement(delta, state)
	handle_shoot()

func handle_movement(delta, state):
	if Input.is_action_pressed("move_forwards"):
		apply_force(state.get_total_gravity() + thrust.rotated(rotation + PI))
	else:
		apply_force(state.get_total_gravity() + Vector2.ZERO)
	var torque_direction = Input.get_axis("rotate_left", "rotate_right")
	var linear_velocity_x = clamp(state.get_linear_velocity().x, -max_velocity, max_velocity)
	var linear_velocity_y = clamp(state.get_linear_velocity().y, -max_velocity, max_velocity)
	state.set_linear_velocity(Vector2(linear_velocity_x, linear_velocity_y))
	print(state.get_linear_velocity())
	apply_torque(torque * torque_direction)
		
func handle_shoot():
	if Input.is_action_just_pressed("shoot") and can_shoot:
		$ShotCooldown.start()
		can_shoot = false
		shoot()

func reset_can_shoot():
	can_shoot = true
	
func shoot():
	if not MUNITION:
		return
	var shot = MUNITION.instantiate()
	shot.add_to_group("bullet")
	shot.position = $Uretra.global_position
	shot.rotation = global_rotation
	get_parent().add_child(shot)

func get_random_death_position():
	var circle = $DeathAura/CollisionShape2D.shape
	var x = randf_range(-circle.radius, circle.radius)
	var y = randf_range(-circle.radius, circle.radius)

	return Vector2(x, y).normalized() + position

func check_collision(body):
	if body.is_in_group("asteroids"):
		morir()

func morir():
	emit_signal("died")
	$Hitbox.set_deferred("disabled", true)
	$HitboxParte2.set_deferred("disabled", true)
	dead = true
	$Sprite2D.hide()
	$AudioStreamPlayer2D.play()

func revivir():
	$Hitbox.set_deferred("disabled", false)
	$HitboxParte2.set_deferred("disabled", false)
	dead = false
	rotation = 0
	$Sprite2D.show()
