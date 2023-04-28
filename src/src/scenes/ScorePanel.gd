extends Control
class_name ScorePanel

# TODO
@onready var icon = get_node("Icon")
@onready var player_name = get_node("TextureName/PlayerName")
@onready var score = get_node("TextureScore/Score")

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


func update_score_panel(rank, name, score):
	icon.texture = images[1]
	player_name.text = name
	score.text = score
