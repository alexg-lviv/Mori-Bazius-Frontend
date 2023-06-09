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


func _on_search_visibility_changed():
	if $Search.visible:
		ScenesTrans.change_main_tab($Search/List, Items.data["arenaria"]["sprite"], $Search/List.position + Vector2(0, 400))
		ScenesTrans.change_main_tab($Search/CreateOrReturn, null, $Search/CreateOrReturn.position + Vector2(0, 400))
		ScenesTrans.change_main_tab($Search/TextureRect, null, $Search/TextureRect.position + Vector2(0, -400))
		
		$Search/CreateOrReturn.scale = Vector2.ONE


func _on_create_visibility_changed():
	if $Create.visible:
		ScenesTrans.change_main_tab($Create/Control, Items.data["arenaria"]["sprite"], $Create/Control.position + Vector2(0, 400))
		ScenesTrans.change_main_tab($Create/TextureRect, null, $Create/TextureRect.position + Vector2(0, -400))
		
		$Create/Control/Back.scale = Vector2.ONE
		$Create/Control/Create.scale = Vector2.ONE


func _on_view_visibility_changed():
	if $View.visible:
		ScenesTrans.change_main_tab($View/Control, Items.data["arenaria"]["sprite"], $View/Control.position + Vector2(0, 400))
		ScenesTrans.change_main_tab($View/Upper, null, $View/Upper.position + Vector2(0, -400))
		
		$View/Control/Back.scale = Vector2.ONE
		$View/Control/JoinButt.scale = Vector2.ONE
		$View/Control/LeaveButt.scale = Vector2.ONE

