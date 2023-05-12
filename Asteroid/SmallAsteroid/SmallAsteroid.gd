extends "res://Asteroid/Asteroid.gd"

func explode():
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.play("explode")
	$Sprite2D.set_scale(Vector2(1.5, 1.5))
	play_explosion_sound()

func init(death_point):
	var direction_vector = position.direction_to(death_point)
	$Sprite2D.set_animation("idle")
	apply_impulse(direction_vector * FORCE)
	angular_velocity = randi_range(-6, 6)
