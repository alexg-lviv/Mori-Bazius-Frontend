extends Control

var credentials := {
	"username": null,
	"password": null,
}

const _register_url := "localhost:8080/user"
const _login_url := "localhost:8081/login/user"

#@onready var _register_get = get_node("RegisterGET") as HTTPRequest
@onready var _register_post = get_node("RegisterPOST") as HTTPRequest
@onready var _login_post = get_node("LoginPOST") as HTTPRequest

@onready var _username_label = get_node("Box/VBoxContainer/Input/Username") as LineEdit
@onready var _password_label = get_node("Box/VBoxContainer/Input/Password") as LineEdit

@onready var _login_button = get_node("Box/VBoxContainer/Buttons/Login") as Button
@onready var _register_button = get_node("Box/VBoxContainer/Buttons/Register") as Button


func _save_credentials():
	credentials["username"] = _username_label.text
	credentials["password"] = _password_label.text


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


#func _on_register_get_request_completed(result, response_code, headers, body):
#	pass # Replace with function body.


func _on_register_post_request_completed(result, response_code, headers, body):
	pass # Replace with function body.


func _on_login_post_request_completed(result, response_code, headers, body):
	pass # Replace with function body.
