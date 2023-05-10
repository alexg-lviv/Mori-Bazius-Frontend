extends Node

var _url := "http://localhost:9000/game_data/%s?player_id=%d"

var _GET_stats = HTTPRequest.new()
var _GET_resources = HTTPRequest.new()

var _POST_stats = HTTPRequest.new()
var _POST_resources = HTTPRequest.new()


signal update_qty(item: String, qty_delta: int)

signal update_exp(exp_delta: int)

signal set_qty()

signal save()

signal pull()


func _ready():
	add_child(_GET_stats)
	add_child(_GET_resources)
	add_child(_POST_stats)
	add_child(_POST_resources)
	
	update_qty.connect(_update_qty)
	update_exp.connect(_update_exp)
	
	save.connect(_on_save)
	pull.connect(_on_pull)
	
	# TODO: bind signal to emit it again if error occured
	_POST_stats.request_completed.connect(_on_post_request_completed)
	_POST_resources.request_completed.connect(_on_post_request_completed)
	
	_GET_stats.request_completed.connect(_on_get_request_completed.bind(Items.stats))
	_GET_resources.request_completed.connect(_on_get_request_completed.bind(Items.qty))


func _update_exp(exp_delta: int):
	Items.stats["exp"] += exp_delta
	Items.stats["level"] = floori(Items.stats["exp"] / 10) + 1
	Items.stats["power"] = Items.power * Items.stats["level"]


func _update_qty(item: String, qty_delta: int):
	if item == "hunter" or item == "master":
		Items.stats[item + "s"] += qty_delta
	else:
		Items.qty[item] += qty_delta
	Items.power += qty_delta * Items.data[item]["power"]
	Items.stats["power"] = Items.power * Items.stats["level"]

func _combine_dict_with_credentials(dict: Dictionary):
	var merged := dict.duplicate()
	merged["player_id"] = Items.credentials["player_id"]
	merged["token"] = Items.credentials["token"]
	merged["player_name"] = Items.credentials["player_name"]
	return merged

func remove_credentials_from_dict(dict: Dictionary):
	for key in ["player_id", "token", "player_name"]:
		dict.erase(key)
	return dict

func _on_save():
	print("Save emitted")
	
	var err_resources = _POST_resources.request(
		_url % ["resources", Items.credentials["player_id"]],
		["Content-Type: application/json"],
		HTTPClient.METHOD_POST,
		JSON.stringify(_combine_dict_with_credentials(Items.qty))
	)
	
	var err_stats = _POST_stats.request(
		_url % ["stats", Items.credentials["player_id"]],
		["Content-Type: application/json"],
		HTTPClient.METHOD_POST,
		JSON.stringify(_combine_dict_with_credentials(Items.stats))
	)
	# TODO: error checks
	
	print(err_resources, err_stats)


func _on_pull():
	print("Load emitted")
	var err_resources = _GET_resources.request(
		_url % ["resources", Items.credentials["player_id"]],
	)

	var err_stats = _GET_stats.request(
		_url % ["stats", Items.credentials["player_id"]],
	)
	# TODO: error checks
	
#	for item in Items.qty:
#		Items.power += Items.qty[item] * Items.data[item]["power"]
#	Items.power += Items.stats["hunters"] * Items.data["hunter"]["power"]
#	Items.power += Items.stats["masters"] * Items.data["master"]["power"]
#
#	Items.stats["power"] = Items.power * Items.stats["level"]


func _on_post_request_completed(_result, response_code, _headers, _body):
	# TODO: error checks
	print(response_code)
	if response_code == 500:
		return

func _on_get_request_completed(_result, response_code, _headers, body, saving_dict):
	# TODO: error checks
	print(response_code)
	saving_dict = remove_credentials_from_dict(JSON.parse_string(body.get_string_from_utf8()))
	print(saving_dict)
	
	if response_code == 500:
		return

	emit_signal("set_qty")
