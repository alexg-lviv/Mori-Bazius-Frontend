extends Control

var credentials := {
	"username": null,
	"password": null,
}

const _register_url := "http://localhost:9000/register"
const _login_url := "http://localhost:9000/login"

var _game_scene = preload("res://src/scenes/Main.tscn").instantiate()

@onready var _username_label = get_node("Box/VBoxContainer/Input/Username") as LineEdit
@onready var _password_label = get_node("Box/VBoxContainer/Input/Password") as LineEdit

@onready var _register_button = get_node("Box/VBoxContainer/Buttons/Register") as Button
@onready var _login_button = get_node("Box/VBoxContainer/Buttons/Login") as Button

@onready var _register_post = get_node("RegisterPOST") as HTTPRequest
@onready var _login_post = get_node("LoginPOST") as HTTPRequest


func _save_credentials():
	credentials["username"] = _username_label.text
	credentials["password"] = _password_label.text
	Items.credentials["player_name"] = credentials["username"]


func _load_game_scene():
	get_tree().get_root().add_child(_game_scene)


func _on_register_pressed():
	_save_credentials()
	
	var err = _register_post.request(
		_register_url,
		["Content-Type: application/json"],
		HTTPClient.METHOD_POST,
		JSON.stringify(credentials)
	)
	print("Sent POST to register with return code ", err)


func _on_login_pressed():
	_save_credentials()

	var err = _login_post.request(
		_login_url,
		["Content-Type: application/json"],
		HTTPClient.METHOD_POST,
		JSON.stringify(credentials)
	)
	print("Sent POST to login with return code ", err)
	# TODO: error checks


func _parse_response(response_code, body):
	if body.get_string_from_utf8() == "\"Internal Server Error\"":
		print("error registring")
		return
	
	var res = JSON.parse_string(JSON.parse_string(body.get_string_from_utf8())) # kek
	
	Items.credentials["player_id"] = int(res["uid"])
	Items.credentials["token"] = res["token"].substr(1, 40)


func _on_register_post_request_completed(_result, response_code, _headers, body):
	# TODO: error checks
#	if response_code != 200:
	print(response_code)
	
	_parse_response(response_code, body)
	
	for item in Items.qty:
		Items.stats["power"] += Items.data[item]["power"] * Items.qty[item]
	Items.stats["power"] += Items.stats["hunters"] * Items.data["hunter"]["power"]
	Items.stats["power"] += Items.stats["masters"] * Items.data["master"]["power"]
		
	Events.emit_signal("save")
	
	_load_game_scene()
	
	queue_free()


func _on_login_post_request_completed(_result, response_code, _headers, body):
	# TODO: error checks
#	if response_code != 200:
	_parse_response(response_code, body)
	
	Events.emit_signal("pull")
	
	_load_game_scene()
	
	queue_free()
	
	# TODO: free or hide curr scene
	
