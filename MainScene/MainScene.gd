extends Node2D

@export var ASTEROID: PackedScene = preload("res://Asteroid/Asteroid.tscn")

func spawn_asteroid():
	var instance = ASTEROID.instantiate()
	add_child(instance)
	var x_pos = randi_range(0, get_viewport_rect().size.x)
	var y_pos = randi_range(0, get_viewport_rect().size.y)
	instance.position = Vector2(x_pos, y_pos)
