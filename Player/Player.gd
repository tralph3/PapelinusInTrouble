extends RigidBody2D

@export var max_velocity = 500.0
@export var thrust = Vector2(0, 550)
@export var torque = 2000.0
@export var MUNITION:  PackedScene = preload("res://Bullet/Bullet.tscn")

var can_shoot = true
var dead = false

var PLAYABLE_AREA_WIDTH = ProjectSettings.get_setting("global/PlayableAreaWidth")
var PLAYABLE_AREA_HEIGHT = ProjectSettings.get_setting("global/PlayableAreaHeight")

signal died

func _ready():
	$Camera2D.limit_top = 0
	$Camera2D.limit_left = 0
	$Camera2D.limit_bottom = PLAYABLE_AREA_HEIGHT
	$Camera2D.limit_right = PLAYABLE_AREA_WIDTH
	position = Vector2(PLAYABLE_AREA_WIDTH/2, PLAYABLE_AREA_HEIGHT/2)

func _integrate_forces(state):
	if not dead:
		handle_input(state)
	else:
		state.set_linear_velocity(Vector2.ZERO)
		state.set_angular_velocity(0.0)
	
func handle_input(state):
	handle_movement(state)
	handle_shoot()

func handle_movement(state):
	if Input.is_action_pressed("move_forwards"):
		apply_force(state.get_total_gravity() + thrust.rotated(rotation + PI))
	else:
		apply_force(state.get_total_gravity() + Vector2.ZERO)
	var torque_direction = Input.get_axis("rotate_left", "rotate_right")
	var linear_velocity_x = clamp(state.get_linear_velocity().x, -max_velocity, max_velocity)
	var linear_velocity_y = clamp(state.get_linear_velocity().y, -max_velocity, max_velocity)
	state.set_linear_velocity(Vector2(linear_velocity_x, linear_velocity_y))
	apply_torque(torque * torque_direction)
	wrap_player_position(state)

func handle_shoot():
	if Input.is_action_pressed("shoot") and can_shoot:
		$ShotCooldown.start()
		can_shoot = false
		shoot()

func wrap_player_position(state):
	if not (state.transform.origin.x <= PLAYABLE_AREA_WIDTH and state.transform.origin.x >= 0 and state.transform.origin.y <= PLAYABLE_AREA_HEIGHT and state.transform.origin.y >= 0):
		play_teleport_sound()
	state.transform.origin.x = fposmod(state.transform.origin.x, PLAYABLE_AREA_WIDTH)
	state.transform.origin.y = fposmod(state.transform.origin.y, PLAYABLE_AREA_HEIGHT)

func reset_can_shoot():
	can_shoot = true
	
func shoot():
	if not MUNITION:
		return
	var shot = MUNITION.instantiate()
	shot.position = $Uretra.global_position
	shot.rotation = global_rotation
	get_parent().call_deferred("add_child", shot)

func get_random_death_position():
	var circle = $DeathAura/CollisionShape2D.shape
	var x = randf_range(-circle.radius, circle.radius)
	var y = randf_range(-circle.radius, circle.radius)

	return Vector2(x, y).normalized() + position

func check_collision(body):
	if body.is_in_group("asteroids") or body.is_in_group("small_asteroids") or body.is_in_group("bullet"):
		morir()

func play_teleport_sound():
	var audio_stream = AudioStreamPlayer.new()
	audio_stream.stream = preload("res://Player/teleport.wav")
	audio_stream.autoplay = true
	audio_stream.connect("finished", audio_stream.queue_free)
	get_parent().add_child(audio_stream)

func morir():
	emit_signal("died")
	$Hitbox.set_deferred("disabled", true)
	dead = true
	$Sprite2D.play("explosion")
	$AudioStreamPlayer2D.play()

func revivir():
	$Hitbox.set_deferred("disabled", false)
	dead = false
	rotation = 0
	$Sprite2D.play("idle")

func powerup_timeout():
	$ShotCooldown.wait_time = 0.4
