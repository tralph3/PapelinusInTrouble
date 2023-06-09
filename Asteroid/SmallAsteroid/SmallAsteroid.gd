extends "res://Asteroid/Asteroid.gd"


@export var small_score = 100

func explode():
	Signals.emit_signal("increase_score", small_score)
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.play("explode")
	play_explosion_sound()

func init(death_point):
	var direction_vector = position.direction_to(death_point)
	$Sprite2D.set_animation("idle")
	$Sprite2D.connect("animation_finished", queue_free)
	apply_impulse(direction_vector * FORCE)
	angular_velocity = randi_range(-6, 6)
