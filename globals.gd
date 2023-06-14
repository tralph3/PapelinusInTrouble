extends Node

var SCORE = 0

func get_score():
	return SCORE

func set_score(score):
	SCORE = score
	Difficulty.update_difficulty_settings()

var settings = {
	"small_asteroid_range": [0, 0],
	"initial_asteroid_impulse_range": [0.0, 0.0],
	"asteroid_limit": 0,
	"asteroid_shield_chance": 0,
	"asteroid_spawn_time": 0
}
