extends Node

@onready var _error_popup = preload("res://src/scenes/UI/ErrorPopup.tscn")

var _url := "http://localhost:9000/game_data/%s?player_id=%d"

var _GET_stats = HTTPRequest.new()
var _GET_resources = HTTPRequest.new()

var _POST_stats = HTTPRequest.new()
var _POST_resources = HTTPRequest.new()

var _POST_stats_errors_counter = 0
var _POST_resources_errors_counter = 0

var _GET_stats_errors_counter = 0
var _GET_resources_errors_counter = 0

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
	_POST_stats.request_completed.connect(_on_post_stats_request_completed)
	_POST_resources.request_completed.connect(_on_post_resources_request_completed)
	
	_GET_stats.request_completed.connect(_on_get_stats_request_completed)
	_GET_resources.request_completed.connect(_on_get_resources_request_completed)


func _update_exp(exp_delta: int):
	Items.stats["exp"] += exp_delta
	Items.stats["level"] = floori(Items.stats["exp"] / 10) + 1


func _update_qty(item: String, qty_delta: int):
	if item == "hunter" or item == "master":
		Items.stats[item + "s"] += qty_delta
	else:
		Items.qty[item] += qty_delta
	Items.stats["power"] += qty_delta * Items.data[item]["power"]


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

# Meni pohui na repetitive code!

func _send_POST_to_stats():
	var attempts = 5
	while attempts >= 0:
		var err_stats = _POST_stats.request(
			_url % ["stats", Items.credentials["player_id"]],
			["Content-Type: application/json"],
			HTTPClient.METHOD_POST,
			JSON.stringify(_combine_dict_with_credentials(Items.stats))
		)
		print("Sent POST to stats with code ", err_stats)
		if err_stats == Error.OK:
			return
		attempts -= 1
	_display_error()


func _send_POST_to_resources():
	var attempts = 5
	while attempts >= 0:
		var err_resources = _POST_resources.request(
			_url % ["resources", Items.credentials["player_id"]],
			["Content-Type: application/json"],
			HTTPClient.METHOD_POST,
			JSON.stringify(_combine_dict_with_credentials(Items.qty))
		)
		print("Sent POST to resources with code ", err_resources)
		if err_resources == Error.OK:
			return
		attempts -= 1
	_display_error()


func _send_GET_to_stats():
	var attempts = 5
	while attempts >= 0:
		var err_stats = _GET_stats.request(
			_url % ["stats", Items.credentials["player_id"]],
		)
		print("Sent GET to stats with code ", err_stats)
		if err_stats == Error.OK:
			return
		attempts -= 1
	_display_error()


func _send_GET_to_resources():
	var attempts = 5
	while attempts >= 0:
		var err_resources = _GET_resources.request(
			_url % ["resources", Items.credentials["player_id"]],
		)
		print("Sent GET to resources with code ", err_resources)
		if err_resources == Error.OK:
			return
		attempts -= 1
	_display_error()


func _on_save():
	_send_POST_to_stats()
	_send_POST_to_resources()
#	var err_resources = _POST_resources.request(
#		_url % ["resources", Items.credentials["player_id"]],
#		["Content-Type: application/json"],
#		HTTPClient.METHOD_POST,
#		JSON.stringify(_combine_dict_with_credentials(Items.qty))
#	)
#	var err_stats = _POST_stats.request(
#		_url % ["stats", Items.credentials["player_id"]],
#		["Content-Type: application/json"],
#		HTTPClient.METHOD_POST,
#		JSON.stringify(_combine_dict_with_credentials(Items.stats))
#	)
#	print("Sent POST to both resources and stats with codes ", err_resources, " and ", err_stats)


func _on_pull():
	_send_GET_to_stats()
	_send_GET_to_resources()
#	var err_resources = _GET_resources.request(
#		_url % ["resources", Items.credentials["player_id"]],
#	)
#	var err_stats = _GET_stats.request(
#		_url % ["stats", Items.credentials["player_id"]],
#	)
#	print("Sent GET to both resources and stats with codes ", err_resources, " and ", err_stats)


#func _on_post_request_completed(_result, response_code, _headers, _body, table):
#	print("POST request to ", table, " completed with code ", response_code)
#	if _POST_errors_counter >= 5:
#		_POST_errors_counter = 0
#		_display_error()
#
#	if response_code != 200:
#		emit_signal("save")
#		_POST_errors_counter += 1


#func _on_get_request_completed(_result, response_code, _headers, body, table):
#	print("GET request to ", table, " completed with code ", response_code)
#
#	if _GET_errors_counter >= 5:
#		_GET_errors_counter = 0
#		_display_error()
#
#	if response_code != 200:
#		emit_signal("pull")
#		_GET_errors_counter += 1
#
#	var data = remove_credentials_from_dict(JSON.parse_string(body.get_string_from_utf8()))
#	if table == "resources":
#		Items.qty = data
#	elif table == "stats":
#		Items.stats = data
#
#	emit_signal("set_qty")


func _on_post_stats_request_completed(_result, response_code, _headers, _body):
	print("POST request to stats completed with code ", response_code)
	if _POST_stats_errors_counter >= 5:
		_POST_stats_errors_counter = 0
		_display_error()
		return
	
	if response_code != 200:
		_send_POST_to_stats()
		_POST_stats_errors_counter += 1


func _on_post_resources_request_completed(_result, response_code, _headers, _body):
	print("POST request to resources completed with code ", response_code)
	if _POST_resources_errors_counter >= 5:
		_POST_resources_errors_counter = 0
		_display_error()
		return
		
	if response_code != 200:
		_send_POST_to_resources()
		_POST_resources_errors_counter += 1


func _on_get_stats_request_completed(_result, response_code, _headers, body):
	print("GET request to stats completed with code ", response_code)
	if _GET_stats_errors_counter >= 5:
		_GET_stats_errors_counter = 0
		_display_error()
		return
	
	if response_code != 200:
		_send_GET_to_stats()
		_GET_stats_errors_counter += 1
		return

	Items.stats = remove_credentials_from_dict(JSON.parse_string(body.get_string_from_utf8()))
	
	emit_signal("set_qty")


func _on_get_resources_request_completed(_result, response_code, _headers, body):
	print("GET request to resources completed with code ", response_code)
	if _GET_resources_errors_counter >= 5:
		_GET_resources_errors_counter = 0
		_display_error()
		return

	if response_code != 200:
		_send_GET_to_resources()
		_GET_resources_errors_counter += 1
		return

	Items.qty = remove_credentials_from_dict(JSON.parse_string(body.get_string_from_utf8()))
	
	emit_signal("set_qty")


func _display_error():
	var popup = _error_popup.instantiate()
	get_tree().get_root().add_child(popup)
	popup.error = "Server error. Please come back later."


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		emit_signal("save")
		await get_tree().create_timer(0.005).timeout
		get_tree().quit() # default behavior
