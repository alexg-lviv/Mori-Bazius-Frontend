extends Control

var one = preload("res://art/UI/tabs_icons/nonactive/resource.png")
var two = preload("res://art/UI/tabs_icons/nonactive/inventory.png")
var three = preload("res://art/UI/tabs_icons/nonactive/monster.png")
var four = preload("res://art/UI/tabs_icons/nonactive/leader.png")

var one_a = preload("res://art/UI/tabs_icons/active/resource.png")
var two_a = preload("res://art/UI/tabs_icons/active/inventory.png")
var three_a = preload("res://art/UI/tabs_icons/active/monster.png")
var four_a = preload("res://art/UI/tabs_icons/active/leader.png")


var active_icon = preload("res://art/UI/tabs_icons/active.png")

var active_icons = {0: one_a, 1: two_a, 2: three_a, 3: four_a}
var icons = {0: one, 1: two, 2: three, 3: four}
var num_tabs = 4

var active = 0

@onready var TabsContainer = get_node("TabContainer")

func _physics_process(_delta):
	for i in range(4):
		if i == active:
			TabsContainer.set_tab_icon(i, active_icons[i])
		else:
			TabsContainer.set_tab_icon(i, icons[i])
		TabsContainer.set_tab_title(i, "")
	
	Events.emit_signal("set_qty")
	
	get_tree().set_auto_accept_quit(false)

	
func _on_save_timer_timeout():
	Events.emit_signal("save")


func _on_tab_container_tab_selected(tab):
	active = tab
