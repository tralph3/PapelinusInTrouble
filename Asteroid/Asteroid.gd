extends RigidBody2D

var FORCE = 300.0

func init(death_point):
	var direction_vector = position.direction_to(death_point)
	$Sprite2D.play("idle")
	apply_impulse(direction_vector * FORCE)

func explode():
	sleeping = true
	$CollisionShape2D.set_deferred("disabled", true)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.play("explosion")
	$Sprite2D.set_scale(Vector2(1.5, 1.5))
	$AudioStreamPlayer2D.play()
	$AudioStreamPlayer2D.connect("finished", queue_free)

func _on_area_2d_area_entered(area):
	if not area.is_in_group("bullet"):
		return
	area.queue_free()
	explode()
