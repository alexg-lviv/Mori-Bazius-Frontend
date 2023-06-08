extends Control

var _url = "http://localhost:9000/members?gid=%s"
var _join_url = "http://localhost:9000/guilds/members/new"
var _leave_url = "http://localhost:9000/guilds/leave?gid=%s&player_id=%d"

var _dict: Dictionary
var _is_full: bool
var _is_joined: bool
var _members_list: Array

@onready var _GET_members = $GetMembers
@onready var _POST_join_guild = $PostJoin
@onready var _DELETE_leave_guild = $DeleteLeave

@onready var _member_entry_scene = preload("res://src/scenes/guilds/Member.tscn")

signal show_search()


func show_guild(dict: Dictionary):
	for child in $VBoxContainer/ScrollContainer/VBoxContainer.get_children():
		$VBoxContainer/ScrollContainer/VBoxContainer.remove_child(child)
		child.queue_free()
	
	_dict = dict
	_is_full = dict["num_members"] == dict["limit_members"]
	_is_joined = false
	if Items.curr_guild:
		_is_joined = _dict["_id"] == Items.curr_guild["_id"]
	
	$VBoxContainer/TextureRect/Label.text = dict["name"]
	$VBoxContainer/VBoxContainer/Description.text = dict["description"]
	$VBoxContainer/VBoxContainer/Mem/Members.text = str(dict["num_members"]) + " / " + str(dict["limit_members"])

	_send_GET_to_members()
	
	if _is_joined:
		$VBoxContainer/HBoxContainer/LeaveButt.visible = true
		$VBoxContainer/HBoxContainer/JoinButt.visible = false
	else:
		$VBoxContainer/HBoxContainer/LeaveButt.visible = false
		if Items.curr_guild:
			$VBoxContainer/HBoxContainer/JoinButt.visible = false
		else:
			$VBoxContainer/HBoxContainer/JoinButt.visible = true


func _send_GET_to_members():
	var attempts = 5
	while attempts >= 0:
		var err = _GET_members.request(
			_url % _dict["_id"],
		)
		print("Sent GET to members with code ", err)

		if err == Error.OK:
			return
		attempts -= 1
#	_display_error()


func _on_get_members_request_completed(result, response_code, headers, body):
	print("GET request to members completed with code ", response_code)
	if response_code == 200:
		print(body.get_string_from_utf8())
		var res = JSON.parse_string(body.get_string_from_utf8())
		if res:
			var i = 1
			for dict in res:
				var entry = _member_entry_scene.instantiate()
				$VBoxContainer/ScrollContainer/VBoxContainer.add_child(entry)
				entry.set_player_data(i, dict["player_name"])
				i += 1


func _on_leave_butt_pressed():
	_send_DELETE_to_members()


func _on_join_butt_pressed():
	_send_POST_to_members()


func _on_back_pressed():
	emit_signal("show_search")


func _send_POST_to_members():
	var d = {
		"gid": _dict["_id"],
		"player_id": Items.credentials["player_id"],
		"player_name": Items.credentials["player_name"],
	}
	
	var attempts = 5
	while attempts >= 0:
		var err = _POST_join_guild.request(
			_join_url,
			["Content-Type: application/json"],
			HTTPClient.METHOD_POST,
			JSON.stringify(d)
		)
		print("Sent POST to members with code ", err)

		if err == Error.OK:
			return
		attempts -= 1
#	_display_error()


func _on_post_join_request_completed(result, response_code, headers, body):
	print("POST request to members completed with code ", response_code)
	if response_code == 200:
		Items.curr_guild = _dict
		show_guild(Items.curr_guild)


func _send_DELETE_to_members():
	var attempts = 5
	while attempts >= 0:
		var err = _DELETE_leave_guild.request(
			_leave_url % [_dict["_id"], Items.credentials["player_id"]],
			[],
			HTTPClient.METHOD_DELETE
		)
		print("Sent DELETE to members with code ", err)

		if err == Error.OK:
			return
		attempts -= 1
#	_display_error()


func _on_delete_leave_request_completed(result, response_code, headers, body):
	print("DELETE request to members completed with code ", response_code)
	if response_code == 200:
		Items.curr_guild = {}
		emit_signal("show_search")
