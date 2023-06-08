extends Control


var one = preload("res://art/UI/main_tabs/resources.png")
var two = preload("res://art/UI/main_tabs/inventory.png")
var three = preload("res://art/UI/main_tabs/monster.png")
var four = preload("res://art/UI/main_tabs/leaderboard.png")
var five = preload("res://art/UI/main_tabs/guilds.png")


var one_a = preload("res://art/UI/main_tabs/resources_pressed.png")
var two_a = preload("res://art/UI/main_tabs/inventory_pressed.png")
var three_a = preload("res://art/UI/main_tabs/monster_pressed.png")
var four_a = preload("res://art/UI/main_tabs/leaderboard_pressed.png")
var five_a = preload("res://art/UI/main_tabs/guilds_pressed.png")


#var one = preload("res://art/UI/tabs_icons/nonactive/resource.png")
#var two = preload("res://art/UI/tabs_icons/nonactive/inventory.png")
#var three = preload("res://art/UI/tabs_icons/nonactive/monster.png")
#var four = preload("res://art/UI/tabs_icons/nonactive/leader.png")
#var five = preload("res://art/UI/tabs_icons/nonactive/guild.png")
#
#var one_a = preload("res://art/UI/tabs_icons/active/resource.png")
#var two_a = preload("res://art/UI/tabs_icons/active/inventory.png")
#var three_a = preload("res://art/UI/tabs_icons/active/monster.png")
#var four_a = preload("res://art/UI/tabs_icons/active/leader.png")
#var five_a = preload("res://art/UI/tabs_icons/active/guild.png")


var active_icon = preload("res://art/UI/tabs_icons/active.png")

var active_icons = {0: one_a, 1: two_a, 2: three_a, 3: four_a, 4: five_a}
var icons = {0: one, 1: two, 2: three, 3: four, 4: five}
var num_tabs = 5

var active = 0


@onready var TabsContainer = get_node("TabContainer")


func _ready():
	for i in range(num_tabs):
		if i == active:
			TabsContainer.set_tab_icon(i, active_icons[i])
		else:
			TabsContainer.set_tab_icon(i, icons[i])
		TabsContainer.set_tab_title(i, "")
	

	Events.emit_signal("set_qty")
	
	get_tree().set_auto_accept_quit(false)  # Handle exit to emit save

	
func _on_save_timer_timeout():
	Events.emit_signal("save")


func _on_tab_container_tab_selected(tab):
	active = tab


func _on_inventory_visibility_changed():
	if not TabsContainer:
		return
	if $TabContainer/Inventory.visible:
		Events.emit_signal("pull_items_stats")
		
		TabsContainer.set_tab_icon(1, active_icons[1])
		await ScenesTrans.change_main_tab($TabContainer/Inventory/Shelf, Items.data["arenaria"]["sprite"], $TabContainer/Inventory/Shelf.position + Vector2(0, 400))
	else:
		TabsContainer.set_tab_icon(1, icons[1])


func _on_home_visibility_changed():
	if not TabsContainer:
		return
	if $TabContainer/Home.visible:
		TabsContainer.set_tab_icon(0, active_icons[0])
	else:
		TabsContainer.set_tab_icon(0, icons[0])


func _on_monsters_visibility_changed():
	if not TabsContainer:
		return
	if $TabContainer/Monsters.visible:
		TabsContainer.set_tab_icon(2, active_icons[2])
		ScenesTrans.change_main_tab($TabContainer/Monsters/Monsters, Items.data["arenaria"]["sprite"], $TabContainer/Monsters/Monsters.position + Vector2(0, 400))
		ScenesTrans.change_main_tab($TabContainer/Monsters/TextureRect, Items.data["arenaria"]["sprite"], $TabContainer/Monsters/TextureRect.position + Vector2(0, -400))
	else:
		TabsContainer.set_tab_icon(2, icons[2])


func _on_leader_board_visibility_changed():
	if not TabsContainer:
		return
	if $TabContainer/LeaderBoard.visible:
		TabsContainer.set_tab_icon(3, active_icons[3])
	else:
		TabsContainer.set_tab_icon(3, icons[3])


func _on_guilds_visibility_changed():
	if not TabsContainer:
		return
	if $TabContainer/Guilds.visible:
		TabsContainer.set_tab_icon(4, active_icons[4])
	else:
		TabsContainer.set_tab_icon(4, icons[4])
