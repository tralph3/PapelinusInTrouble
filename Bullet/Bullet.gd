extends Area2D

var SPEED = 300

func delete():
	queue_free()

func _physics_process(delta):
	var direction = Vector2(cos(rotation - PI/2), sin(rotation - PI/2))
	var velocity = direction * SPEED * delta
	position += velocity
