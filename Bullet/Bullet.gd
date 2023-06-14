extends RigidBody2D

var SPEED = Vector2(0, 700)
var latest_two_positions = [Vector2.ZERO, Vector2.ZERO]

func update_positions():
	latest_two_positions[0] = latest_two_positions[1]
	latest_two_positions[1] = position

func set_initial_positions(pos1, pos2):
	latest_two_positions = [pos1, pos2]

func _ready():
	var audio_player = AudioStreamPlayer.new()
	audio_player.stream = preload("res://Bullet/shoot.wav")
	audio_player.autoplay = true
	audio_player.connect("finished", audio_player.queue_free)
	get_parent().add_child(audio_player)
	apply_impulse(SPEED.rotated(rotation + PI))

func _physics_process(_delta):
	update_positions()

func get_latest_positions():
	return latest_two_positions
