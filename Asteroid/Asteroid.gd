extends RigidBody2D

const FORCE = 300.0

# si spawneamos los asteroides chiquitos adentro
# de este, este nodo necesita acceder a la
# camara del jugador y es un quilombo
signal spawn_small_asteroids(position, small_asteroids_amount)

var small_asteroid: PackedScene = load("res://Asteroid/SmallAsteroid/SmallAsteroid.tscn")
var shield: PackedScene = load("res://Asteroid/AsteroidShield/AsteroidShield.tscn")

var small_asteroids_to_spawn_on_death = randi_range(1, 4)

@export var shield_spawn_probability = 0.3

var animation_finished = false
var death_sound_finished = false

var shields = []

func try_to_die():
	if animation_finished and death_sound_finished:
		queue_free()

func set_animation_finished():
	animation_finished = true
	try_to_die()

func spawn_shield():
	var spawn_radius = $ShieldSpawnArea/CollisionShape2D.shape.radius
	var random_angle = randf_range(0, 2*PI)
	var spawn_position = Vector2(spawn_radius * cos(random_angle), spawn_radius * sin(random_angle))
	var new_shield = shield.instantiate()
	new_shield.position = spawn_position
	new_shield.rotation = spawn_position.angle() - PI/2
	shields.append(new_shield)
	add_child(new_shield)

func set_death_sound_finished():
	death_sound_finished = true
	try_to_die()

func init(death_point):
	var direction_vector = position.direction_to(death_point)
	$Sprite2D.set_animation("idle")
	apply_impulse(direction_vector * FORCE)
	if randf_range(0, 1) <= shield_spawn_probability:
		spawn_shield()
	angular_velocity = randi_range(-6, 6)

func play_explosion_sound():
	var audio_stream = AudioStreamPlayer2D.new()
	audio_stream.stream = preload("res://Asteroid/asteroid_explosion.wav")
	audio_stream.autoplay = true
	audio_stream.connect("finished", audio_stream.queue_free)
	audio_stream.volume_db += 20
	get_parent().add_child(audio_stream)

func explode():
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.play("explode")
	$Sprite2D.set_scale(Vector2(1.5, 1.5))
	play_explosion_sound()
	for shield in shields:
		if shield != null and not shield.is_queued_for_deletion():
			shield.queue_free()
	emit_signal("spawn_small_asteroids", position, small_asteroids_to_spawn_on_death)

func _on_body_entered(body):
	if not body.is_in_group("bullet"):
		return
	body.queue_free()
	explode()
