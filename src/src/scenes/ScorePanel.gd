extends Control
class_name ScorePanel

@onready var icon = get_node("Icon")
@onready var _rank = get_node("Icon/HBoxContainer/Label")
@onready var _player_name = get_node("Icon/HBoxContainer/PlayerName")
@onready var _score = get_node("Icon/HBoxContainer/Score")

var images: Dictionary = {
	1: load("res://art/UI/rank.png")
}

const players_data: Dictionary = {
	"Player1 Name": {
		"rank": 1,
		"score": 1000
	},
	"Player2 Name": {
		"rank": 2,
		"score": 100
	}
}

func update_score_panel(rank, name_, score):
	_rank.text = str(rank)
#	icon.texture = images[1]
	_player_name.text = name_
	_score.text = str(score)
