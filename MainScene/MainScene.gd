extends Node2D

@export var ASTEROID: PackedScene = preload("res://Asteroid/Asteroid.tscn")
@export var OFFSCREEN_OFFSET = 200

func spawn_asteroid():
	var death_point = $Player.get_random_death_position()
	var instance = ASTEROID.instantiate()
	instance.add_to_group("asteroids")
	print("Generated: %s" % death_point)
	add_child(instance)
	var x_pos = randi_range(-200, get_viewport_rect().size.x)
	var y_pos = randi_range(-200, get_viewport_rect().size.y)
	instance.position = get_asteroid_spawn_pos()
	instance.init(death_point)

func get_asteroid_spawn_pos():
	var resulting_position = Vector2.ZERO
	var viewport_x = get_viewport_rect().size.x
	var viewport_y = get_viewport_rect().size.y
	var x1 = randi_range(-OFFSCREEN_OFFSET, 0)
	var x2 = randi_range(viewport_x, viewport_x + OFFSCREEN_OFFSET)
	var y1 = randi_range(-OFFSCREEN_OFFSET, 0)
	var y2 = randi_range(viewport_y, viewport_y + OFFSCREEN_OFFSET)
	if randi() % 2 == 0:
		resulting_position.x = x1
	else:
		resulting_position.x = x2

	if randi() % 2 == 0:
		resulting_position.y = y1
	else:
		resulting_position.y = y2
	
	return resulting_position
