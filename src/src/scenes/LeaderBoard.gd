extends Control

# TODO URL
var _url := "http://localhost:9000/game_data/leaderboard?limit=%d"
var _num := 100
var _err_counter := 0

@onready var row = preload("res://src/scenes/ScorePanel.tscn")
@onready var container = get_node("ScrollContainer/VBoxContainer")

@onready var _GET = get_node('GET')

@onready var _curr_player = get_node("CurrPlayer") as ScorePanel


func _ready():
	_curr_player.icon.material = load("res://materials/leaderboard_row_outline.tres")


func _get_leaderboard():
	var attempts = 5
	while attempts >= 0:
		var err = _GET.request(
			_url % _num,
		)
		print("Sent GET to leaderboard with code ", err)
		if err == Error.OK:
			return
		attempts -= 1
	_display_error()


func _on_get_request_completed(result, response_code, headers, body):
	print("GET request to leaderboard completed with code ", response_code)
	if _err_counter >= 5:
		_err_counter = 0
		_display_error()
		return
	
	if response_code != 200:
		_get_leaderboard()
		_err_counter += 1
		return
	
	var res = JSON.parse_string(body.get_string_from_utf8())
	res.sort_custom(func(a, b): return a["power"] > b["power"])  # TODO: senior kostyl
	for i in range(len(res)):
		var instance: ScorePanel = row.instantiate()
		container.add_child(instance)
		instance.update_score_panel(i + 1, res[i]["player_name"], res[i]["power"])
		if res[i]["player_id"] == Items.credentials["player_id"]:
			instance.icon.material = load("res://materials/leaderboard_row_outline.tres")
			_curr_player.update_score_panel(i + 1, res[i]["player_name"], res[i]["power"])


func _on_visibility_changed():
	if not visible:
		return

	for r in container.get_children():
		container.remove_child(r)
		r.queue_free()

	_curr_player.update_score_panel("-", Items.credentials["player_name"], Items.stats["power"])
	_get_leaderboard()


func _display_error():
	pass
