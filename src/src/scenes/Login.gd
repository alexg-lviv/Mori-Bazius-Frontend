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


func _on_register_post_request_completed(_result, response_code, _headers, body):
	# TODO: error checks
#	if response_code != 200:
	if body.get_string_from_utf8() == "\"Internal Server Error\"":
		print("error registring")
		return
	
	Items.credentials["player_id"] = int(body.get_string_from_utf8())


func _on_login_post_request_completed(_result, response_code, _headers, body):
	# TODO: error checks
#	if response_code != 200:
	if body.get_string_from_utf8() == "\"Internal Server Error\"":
		print("error logging")
		return
	
	Items.credentials["token"] = body.get_string_from_utf8().substr(7, 40)
	Items.credentials["player_name"] = credentials["username"]
	
	_load_game_scene()
	
	# TODO: free or hide curr scene
