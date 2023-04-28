extends Control

# TODO URL
var _url: String

@onready var row = preload("res://src/scenes/ScorePanel.tscn")
@onready var container = get_node("Background/ScrollContainer/VBoxContainer")

@onready var _GET = get_node('GET')

func set_leaderboard():
	#_GET.request(_url)
	pass

func _on_get_request_completed(result, response_code, headers, body):
	var res = JSON.parse_string(body.get_string_from_utf8())
	if res:
		var instance: ScorePanel = row.instantiate()
		instance.update_score_panel("", "", "")
		container.add_child(instance)
	else:
		# TODO: jsonification error
		pass
	
	
