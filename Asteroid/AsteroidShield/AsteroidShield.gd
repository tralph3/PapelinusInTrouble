extends StaticBody2D

func play_hit_sound():
	var audio_player = AudioStreamPlayer.new()
	audio_player.stream = preload("res://Asteroid/AsteroidShield/shield_destroyed.wav")
	audio_player.autoplay = true
	audio_player.connect("finished", audio_player.queue_free)
	get_parent().add_child(audio_player)

func _on_area_2d_body_entered(body):
	if body.is_in_group("bullet"):
		play_hit_sound()
		queue_free()
