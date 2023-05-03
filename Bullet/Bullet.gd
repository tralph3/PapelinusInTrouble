extends RigidBody2D

var SPEED = Vector2(0, 700)

func _ready():
	$VisibleOnScreenNotifier2D.connect("screen_exited", queue_free)
	apply_impulse(SPEED.rotated(rotation + PI))
