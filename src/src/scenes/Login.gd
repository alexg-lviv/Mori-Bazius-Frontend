extends Control

var credentials := {
	"username": null,
	"password": null,
}

const _register_url := "http://localhost:9000/register"
const _login_url := "http://localhost:9000/login"

var _game_scene = preload("res://src/scenes/Main.tscn").instantiate()

var _err_tween

@onready var _username_label = get_node("Box/VBoxContainer/Input/Username") as LineEdit
@onready var _password_label = get_node("Box/VBoxContainer/Input/Password") as LineEdit

@onready var _error_label = get_node("Box/VBoxContainer/Error") as Label

@onready var _register_button = get_node("Box/VBoxContainer/Buttons/Register") as Button
@onready var _login_button = get_node("Box/VBoxContainer/Buttons/Login") as Button

@onready var _register_post = get_node("RegisterPOST") as HTTPRequest
@onready var _login_post = get_node("LoginPOST") as HTTPRequest


func _ready():
	_error_label.visible_ratio = 0


func _save_credentials():
	if _username_label.text == "" or _password_label.text == "":
		return false
	credentials["username"] = _username_label.text
	credentials["password"] = _password_label.text
	Items.credentials["player_name"] = credentials["username"]
	return true


func _load_game_scene():
	get_tree().get_root().add_child(_game_scene)


func _on_register_pressed():
	if not _save_credentials():
		return
	
	var err = _register_post.request(
		_register_url,
		["Content-Type: application/json"],
		HTTPClient.METHOD_POST,
		JSON.stringify(credentials)
	)
	print("Sent POST to register with return code ", err)


func _on_login_pressed():
	if not _save_credentials():
		return

	var err = _login_post.request(
		_login_url,
		["Content-Type: application/json"],
		HTTPClient.METHOD_POST,
		JSON.stringify(credentials)
	)
	print("Sent POST to login with return code ", err)
	# TODO: error checks


func _show_error(text: String):
	_error_label.text = text
	var tween = get_tree().create_tween()
	tween.tween_property(_error_label, "visible_ratio", 1, 0.1)
	tween.tween_property(_error_label, "visible_ratio", 0, 0.1).set_delay(2)
	await get_tree().create_timer(2.2).timeout
	_error_label.text = ""


func _parse_response(response_code, body):
	print(response_code, body.get_string_from_utf8())
	var res = body.get_string_from_utf8()
	if "Invalid Credentials" in res:
		_show_error("Invalid username or password.")
		return false
	elif "user already exists" in res:
		_show_error("This username is already taken.")
		return false
	elif "Internal Server Error" in res:
		_show_error("Error occured. Try later.")
		return false
#
	res = JSON.parse_string(JSON.parse_string(res)) # kek
	
	Items.credentials["player_id"] = int(res["uid"])
	Items.credentials["token"] = res["token"].substr(1, 40)
	
	return true


func _on_register_post_request_completed(_result, response_code, _headers, body):
	# TODO: error checks
#	if response_code != 200:
	
	if not _parse_response(response_code, body):
		return
	
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
	if not _parse_response(response_code, body):
		return
	
	Events.emit_signal("pull")
	
	_load_game_scene()
	
	queue_free()
