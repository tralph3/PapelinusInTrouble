extends RigidBody2D

var SPEED = Vector2(0, 700)
var latest_two_positions = [Vector2.ZERO, Vector2.ZERO]
var PLAYABLE_AREA_WIDTH = ProjectSettings.get_setting("global/PlayableAreaWidth")
var PLAYABLE_AREA_HEIGHT = ProjectSettings.get_setting("global/PlayableAreaHeight")
var MARGIN = 300

func update_positions():
	latest_two_positions[0] = latest_two_positions[1]
	latest_two_positions[1] = position

func set_initial_positions(pos1, pos2):
	latest_two_positions = [pos1, pos2]
	
func delete_when_out_of_bounds(state):
	if not (state.transform.origin.x <= PLAYABLE_AREA_WIDTH + MARGIN and state.transform.origin.x >= -MARGIN and state.transform.origin.y <= PLAYABLE_AREA_HEIGHT + MARGIN and state.transform.origin.y >= -MARGIN):
		queue_free()

func _ready():
	var audio_player = AudioStreamPlayer.new()
	audio_player.stream = preload("res://Bullet/shoot.wav")
	audio_player.autoplay = true
	audio_player.connect("finished", audio_player.queue_free)
	get_parent().add_child(audio_player)
	apply_impulse(SPEED.rotated(rotation + PI))

func _integrate_forces(state):
	delete_when_out_of_bounds(state)
	update_positions()

func get_latest_positions():
	return latest_two_positions
