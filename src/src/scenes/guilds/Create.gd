extends Control


var _url := "http://localhost:9000/guilds/new"

var _sending_dict := {
	"name": "",
	"description": "",
	"limit_members": 20,
	"player_id": 0,
	"player_name": "",
}

signal show_view(gid)

signal show_search()

@onready var _POST := $POST

@onready var _guild_view_scene = preload("res://src/scenes/guilds/View.tscn")


func _send_POST_to_guilds_new():
	var attempts = 5
	while attempts >= 0:
		var err = _POST.request(
			_url,
			["Content-Type: application/json"],
			HTTPClient.METHOD_POST,
			JSON.stringify(_save_info())
		)
		print("Sent POST to guilds/new with code ", err)
		if err == Error.OK:
			return
		attempts -= 1
#	_display_error()


func _save_info():
	_sending_dict["name"] = $Input/Title.text
	_sending_dict["description"] = $Input/Description.text
	_sending_dict["player_id"] = Items.credentials["player_id"]
	_sending_dict["player_name"] = Items.credentials["player_name"]
	return _sending_dict


func _on_post_request_completed(result, response_code, headers, body):
	print("POST request to guilds/new completed with code ", response_code)
	if response_code == 200:
		var res = JSON.parse_string(body.get_string_from_utf8())
		if res:
			var gid = res["gid"]
			emit_signal("show_view", gid)
			
#	if _POST_stats_errors_counter >= 5:
#		_POST_stats_errors_counter = 0
#		_display_error()
#		return
#
#	if response_code != 200:
#		_send_POST_to_stats()
#		_POST_stats_errors_counter += 1


func _on_create_pressed():
	_save_info()
	_send_POST_to_guilds_new()


func _on_back_pressed():
	emit_signal("show_search")
