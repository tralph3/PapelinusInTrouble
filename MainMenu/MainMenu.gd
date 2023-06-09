extends Control

func start_the_game_already():
	get_tree().change_scene_to_file("res://MainScene/MainScene.tscn")

func quit():
	get_tree().quit()
