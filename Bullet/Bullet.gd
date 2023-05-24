extends RigidBody2D

var SPEED = Vector2(0, 700)

func _ready():
	$VisibleOnScreenNotifier2D.connect("screen_exited", queue_free)
	var audio_player = AudioStreamPlayer.new()
	audio_player.stream = preload("res://Bullet/shoot.wav")
	audio_player.autoplay = true
	audio_player.connect("finished", audio_player.queue_free)
	get_parent().add_child(audio_player)
	apply_impulse(SPEED.rotated(rotation + PI))
