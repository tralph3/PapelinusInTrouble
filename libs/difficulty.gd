extends Node

func update_difficulty_settings():
	var score = Globals.SCORE
	if score < 5000:
		Globals.settings["small_asteroid_range"] = [0, 0]
		Globals.settings["initial_asteroid_impulse_range"] = [150.0, 180.0]
		Globals.settings["asteroid_limit"] = 10
		Globals.settings["asteroid_shield_chance"] = 0
		Globals.settings["asteroid_spawn_time"] = 2
	elif score < 10000:
		Globals.settings["small_asteroid_range"] = [0, 3]
		Globals.settings["initial_asteroid_impulse_range"] = [200.0, 230.0]
		Globals.settings["asteroid_limit"] = 20
		Globals.settings["asteroid_shield_chance"] = 0.2
		Globals.settings["asteroid_spawn_time"] = 1.5
	elif score < 15000:
		Globals.settings["small_asteroid_range"] = [1, 5]
		Globals.settings["initial_asteroid_impulse_range"] = [230.0, 260.0]
		Globals.settings["asteroid_limit"] = 30
		Globals.settings["asteroid_shield_chance"] = 0.4
		Globals.settings["asteroid_spawn_time"] = 1
	elif score < 20000:
		Globals.settings["small_asteroid_range"] = [3, 6]
		Globals.settings["initial_asteroid_impulse_range"] = [260.0, 280.0]
		Globals.settings["asteroid_limit"] = 40
		Globals.settings["asteroid_shield_chance"] = 0.5
		Globals.settings["asteroid_spawn_time"] = 1
	elif score < 30000:
		Globals.settings["small_asteroid_range"] = [4, 8]
		Globals.settings["initial_asteroid_impulse_range"] = [250.0, 400.0]
		Globals.settings["asteroid_limit"] = 60
		Globals.settings["asteroid_shield_chance"] = 0.7
		Globals.settings["asteroid_spawn_time"] = 0.5
