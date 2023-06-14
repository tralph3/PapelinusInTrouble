extends Control

func _ready():
	Signals.connect("increase_score", add_to_score)
	Signals.connect("set_score", set_score)

func set_score(score):
	Globals.set_score(score)
	$ScoreCounter.text = str(Globals.get_score())

func add_to_score(score):
	Globals.set_score(Globals.get_score() + score)
	$ScoreCounter.text = str(Globals.get_score())
