extends RigidBody2D

var FORCE = 300.0

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

func explode():
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.play("explode")
	$Sprite2D.set_scale(Vector2(1.5, 1.5))
	$AudioStreamPlayer2D.play()

func _on_body_entered(body):
	if not body.is_in_group("bullet"):
		return
	body.queue_free()
	explode()
