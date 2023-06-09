extends Node2D

var METRALLETA_POWERUP: PackedScene = preload("res://Powerups/Metralleta/Metralleta.tscn")

@export var ASTEROID: PackedScene = preload("res://Asteroid/Asteroid.tscn")
@export var SMALL_ASTEROID: PackedScene = preload("res://Asteroid/SmallAsteroid/SmallAsteroid.tscn")
@export var OFFSCREEN_OFFSET: int = 200
var PLAYABLE_AREA_WIDTH = ProjectSettings.get_setting("global/PlayableAreaWidth")
var PLAYABLE_AREA_HEIGHT = ProjectSettings.get_setting("global/PlayableAreaHeight")
const MAX_ASTEROIDS_IN_SCENE = 3000
var game_over = false

func _ready():
	$Player.connect("died", finish_game)
	$SpawnTimer.connect("timeout", spawn_asteroid)
	$PlayerSpawnPoint.position = Vector2(PLAYABLE_AREA_WIDTH/2, PLAYABLE_AREA_HEIGHT/2)
	setup_powerup_timer()

func finish_game():
	game_over = true
	$SpawnTimer.stop()
	show_game_over_banner()

func show_game_over_banner():
	$GameOverBanner.position = $Player/Camera2D.get_screen_center_position()
	$GameOverBanner.visible = true
	$GameOverBanner.stop()
	$GameOverBanner.play_backwards("default")

func _process(_delta):
	handle_input()

func handle_input():
	if game_over and Input.is_action_just_pressed("restart"):
		restart_game()
	if Input.is_action_pressed("open_menu"):
		get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")

func setup_powerup_timer():
	var timer_length = randi_range(10, 30)
	$PowerupSpawn.stop()
	$PowerupSpawn.wait_time = timer_length
	$PowerupSpawn.start()

func spawn_powerup():
	var powerup_spawnpos = Vector2(randi_range(0, PLAYABLE_AREA_WIDTH), 0)
	var powerup = METRALLETA_POWERUP.instantiate()
	powerup.position = powerup_spawnpos
	add_child(powerup)
	setup_powerup_timer()

func restart_game():
	Signals.emit_signal("set_score", 0)
	setup_powerup_timer()
	$Player.powerup_timeout()
	$SpawnTimer.start()
	$GameOverBanner.visible = false
	game_over = false
	delete_all_game_objects()
	$Player.revivir()
	$Player.position = $PlayerSpawnPoint.position

func delete_all_game_objects():
	get_tree().call_group("asteroids", "queue_free")
	get_tree().call_group("small_asteroids", "queue_free")
	get_tree().call_group("powerups", "queue_free")

func spawn_asteroid():
	var asteroid_count = len(get_tree().get_nodes_in_group("asteroids"))
	if game_over or asteroid_count >= MAX_ASTEROIDS_IN_SCENE:
		return
	var death_point = $Player.get_random_death_position()
	var asteroid = instance_asteroid()
	asteroid.init(death_point)
	asteroid.connect("spawn_small_asteroids", spawn_small_asteroids)
	add_child(asteroid)

func spawn_small_asteroids(position, small_asteroid_amount):
	for _i in range(small_asteroid_amount):
		spawn_small_asteroid(position)

func spawn_small_asteroid(position):
	var small_asteroid_instance = SMALL_ASTEROID.instantiate()
	var camera_center = $Player/Camera2D.get_screen_center_position()
	var screen_size_x = get_viewport_rect().size.x
	var screen_size_y = get_viewport_rect().size.y
	var random_point_x = randf_range(camera_center.x - screen_size_x / 2, camera_center.x + screen_size_x / 2)
	var random_point_y = randf_range(camera_center.y - screen_size_y / 2, camera_center.y + screen_size_y / 2)
	var random_point = Vector2(random_point_x, random_point_y)
	small_asteroid_instance.position = position
	small_asteroid_instance.init(random_point)
	call_deferred("add_child", small_asteroid_instance)

func instance_asteroid():
	var instance = ASTEROID.instantiate()
	instance.position = get_asteroid_spawn_pos()
	return instance

func get_asteroid_spawn_pos():
	var resulting_position = Vector2.ZERO
	var viewport_x = get_viewport_rect().size.x
	var viewport_y = get_viewport_rect().size.y
	
	var camera_center = $Player/Camera2D.get_screen_center_position()
	var left_margin = camera_center.x - viewport_x / 2
	var right_margin = camera_center.x + viewport_x / 2
	var top_margin = camera_center.y - viewport_y / 2
	var bottom_margin = camera_center.y + viewport_y / 2
	
	var x1 = randi_range(left_margin - OFFSCREEN_OFFSET, left_margin)
	var x2 = randi_range(right_margin, right_margin + OFFSCREEN_OFFSET)
	var y1 = randi_range(top_margin - OFFSCREEN_OFFSET, top_margin)
	var y2 = randi_range(bottom_margin, bottom_margin + OFFSCREEN_OFFSET)
	if randi() % 2 == 0:
		resulting_position.x = x1
	else:
		resulting_position.x = x2

	if randi() % 2 == 0:
		resulting_position.y = y1
	else:
		resulting_position.y = y2
	
	return resulting_position
