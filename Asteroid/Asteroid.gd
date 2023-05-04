extends RigidBody2D

const FORCE = 300.0

var small_asteroid: PackedScene = load("res://Asteroid/SmallAsteroid/SmallAsteroid.tscn")

var small_asteroids_to_spawn_on_death = 4

var animation_finished = false
var death_sound_finished = false

func try_to_die():
	if animation_finished and death_sound_finished:
		queue_free()

func set_animation_finished():
	animation_finished = true
	try_to_die()

func set_death_sound_finished():
	death_sound_finished = true
	try_to_die()

func init(death_point):
	var direction_vector = position.direction_to(death_point)
	$Sprite2D.set_animation("idle")
	apply_impulse(direction_vector * FORCE)
	angular_velocity = randi_range(-6, 6)

func spawn_small_asteroid():
	var small_asteroid_instance = small_asteroid.instantiate()
	var random_point_x = randf_range(0, get_viewport_rect().size.x)
	var random_point_y = randf_range(0, get_viewport_rect().size.y)
	var random_point = Vector2(random_point_x, random_point_y)
	small_asteroid_instance.position = self.position
	small_asteroid_instance.init(random_point)
	get_parent().add_child(small_asteroid_instance)

func explode():
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.play("explode")
	$Sprite2D.set_scale(Vector2(1.5, 1.5))
	$AudioStreamPlayer2D.play()
	for _i in range(small_asteroids_to_spawn_on_death):
		spawn_small_asteroid()

func _on_body_entered(body):
	if not body.is_in_group("bullet"):
		return
	body.queue_free()
	explode()
