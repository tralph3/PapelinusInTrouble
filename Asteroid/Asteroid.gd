extends "res://libs/Proyectil.gd"

var SIZES = [0.5, 1]
var level = -1

signal spawn_child_asteroids(level, position)

func init(death_point, level):
	var direction_vector = position.direction_to(death_point)
	$Sprite2D.play("idle")
	level = level
	var size = SIZES[level]
	set_scale(Vector2(size, size))
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
	if level > 0:
		emit_signal("spawn_child_asteroids", level, position)
	explode()
