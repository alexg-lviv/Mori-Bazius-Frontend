extends Control


@onready var _GET_curr_guild := $GetCurrGuild


#func _ready():
#	_manage_guilds()
#
	
func _manage_guilds():
	$Search.visible = false
	$Create.visible = false
	$View.visible = false

	_GET_curr_guild.cancel_request()
	_get_current_guild()


func _get_current_guild():
	var attempts = 5
	while attempts >= 0:
		var err = _GET_curr_guild.request(
			"http://localhost:9000/guild?player_id=%d" % Items.credentials["player_id"]
		)
		print("Sent GET to guild with code ", err)
		if err == Error.OK:
			return
		attempts -= 1
#	_display_error()


func _on_get_curr_guild_request_completed(_result, response_code, _headers, body):
	print("GET request to guild completed with code ", response_code)
	var res = JSON.parse_string(body.get_string_from_utf8())
	print(res)
	if res:
		Items.curr_guild = res
		_show_my_guild()
	else:
		_show_search()


func _show_my_guild():
	$View.visible = true
	$View.show_guild(Items.curr_guild)
	
	$Search.visible = false
	$Create.visible = false


func _show_search():
	$Search.visible = true
	$Search.show_guilds_list()
	
	$View.visible = false
	$Create.visible = false
	

func _on_search_show_creation():
	$Create.visible = true
	$Search.visible = false
	$View.visible = false


func _on_search_show_view(dict):
	$View.visible = true
	$View.show_guild(dict)
	
	$Search.visible = false
	$Create.visible = false


func _on_create_show_view(gid):
	_get_current_guild()


func _on_create_show_search():
	$Search.visible = true
	$Search.show_guilds_list()
	
	$View.visible = false
	$Create.visible = false


func _on_view_show_search():
	$Search.visible = true
	$Search.show_guilds_list()
	
	$View.visible = false
	$Create.visible = false


func _on_visibility_changed():
	if visible:
		_manage_guilds()
