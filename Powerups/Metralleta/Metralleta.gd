extends AnimatedSprite2D


var PLAYABLE_AREA_WIDTH = ProjectSettings.get_setting("global/PlayableAreaWidth")
var PLAYABLE_AREA_HEIGHT = ProjectSettings.get_setting("global/PlayableAreaHeight")
const SPEED = 200

func _ready():
	play("default")

func _physics_process(delta):
	position += Vector2(0, SPEED * delta)
	if is_out_of_bounds():
		queue_free()

func is_out_of_bounds():
	return not (position.x <= PLAYABLE_AREA_WIDTH and position.x >= 0 and position.y <= PLAYABLE_AREA_HEIGHT and position.y >= 0)

func apply_powerup(player):
	player.get_node("ShotCooldown").wait_time = 0.1
	player.get_node("PowerupTimer").stop()
	player.get_node("PowerupTimer").start()
	queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		apply_powerup(body)
