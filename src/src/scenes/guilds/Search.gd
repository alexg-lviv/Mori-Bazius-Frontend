extends Control

var _url = "http://localhost:9000/guilds?limit=%d"

@onready var _GET_list = $GetList

@onready var _entry_scene = preload("res://src/scenes/guilds/SearchEntry.tscn")

signal show_creation()
signal show_view(dict)


func show_guilds_list():
	if Items.curr_guild:
		$CreateOrReturn/Label.text = "Return"
	else:
		$CreateOrReturn/Label.text = "Create"
	_send_GET_to_guilds()
	
	for old_entry in $List/VBoxContainer.get_children():
		$List/VBoxContainer.remove_child(old_entry)
		old_entry.queue_free()


func _add_entry(dict):
	var scene = _entry_scene.instantiate()
	$List/VBoxContainer.add_child(scene)
	scene._dict = dict
	scene.show_view.connect(_show_view)


func _send_GET_to_guilds():
	var attempts = 5
	while attempts >= 0:
		var err = _GET_list.request(
			_url % 20,
		)
		print("Sent GET to guilds with code ", err)

		if err == Error.OK:
			return
		attempts -= 1
#	_display_error()


func _on_get_list_request_completed(result, response_code, headers, body):
	print("GET request to guilds completed with code ", response_code)
	if response_code == 200:
		var j = JSON.new()
		var res = JSON.parse_string(body.get_string_from_utf8())
		
		if res:
			for dict in res:
				_add_entry(dict)


func _show_view(dict):
	emit_signal("show_view", dict)


func _on_create_pressed():
	if Items.curr_guild:
		emit_signal("show_view", Items.curr_guild)
	else:
		emit_signal("show_creation")


