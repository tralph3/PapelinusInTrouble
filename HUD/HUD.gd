extends Control

func _ready():
	Signals.connect("increase_score", add_to_score)
	Signals.connect("set_score", set_score)

func set_score(score):
	$ScoreCounter.text = str(score)

func add_to_score(score):
	var current_score = int($ScoreCounter.text)
	$ScoreCounter.text = str(current_score + score)
