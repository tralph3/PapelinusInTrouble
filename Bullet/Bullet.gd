extends Area2D

var SPEED = 700

var direction = Vector2.ZERO

func _ready():
	$VisibleOnScreenNotifier2D.connect("screen_exited", queue_free)
	direction = Vector2(cos(rotation - PI/2), sin(rotation - PI/2))

func _physics_process(delta):
	var velocity = direction * SPEED * delta
	position += velocity
