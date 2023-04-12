extends Node2D

@export var ASTEROID: PackedScene = preload("res://Asteroid/Asteroid.tscn")
@export var OFFSCREEN_OFFSET = 200

var game_over = false

func _ready():
	$Player.connect("died", finish_game)

func finish_game():
	game_over = true
	$SpawnTimer.stop()
	show_game_over_banner()

func show_game_over_banner():
	$GameOverBanner.position = $Player/Camera2D.get_screen_center_position()
	$GameOverBanner.visible = true

func _process(delta):
	handle_input()

func _physics_process(delta):
	var area = $PlayableArea/CollisionShape2D
	var left_margin = area.global_position.x - area.shape.get_rect().size.x / 2
	var right_margin = area.global_position.x + area.shape.get_rect().size.x / 2
	var top_margin = area.global_position.y - area.shape.get_rect().size.y / 2
	var bottom_margin = area.global_position.y + area.shape.get_rect().size.y / 2
	$Player.position.x = clamp($Player.position.x, left_margin, right_margin)
	$Player.position.y = clamp($Player.position.y, top_margin, bottom_margin)

func handle_input():
	if game_over and Input.is_action_just_pressed("restart"):
		restart_game()

func restart_game():
	$SpawnTimer.start()
	$GameOverBanner.visible = false
	game_over = false
	$Player.revivir()
	$Player.position = $PlayerSpawnPoint.position

func spawn_asteroid():
	if game_over:
		return
	var death_point = $Player.get_random_death_position()
	var instance = ASTEROID.instantiate()
	instance.add_to_group("asteroids")
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
