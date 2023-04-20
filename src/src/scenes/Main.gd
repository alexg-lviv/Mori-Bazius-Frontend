extends Control

var home_icon = preload("res://icon.svg")
var leadboard_icon = preload("res://icon.svg")
var guild_icon = preload("res://icon.svg")
var inventory_icon = preload("res://icon.svg")
var witchers_icon = preload("res://icon.svg")

var num_tabs = 5

@onready var TabsContainer = get_node("TabContainer")

func _ready():
	TabsContainer.set_tab_icon(0, home_icon)
	TabsContainer.set_tab_icon(1, leadboard_icon)
	TabsContainer.set_tab_icon(2, guild_icon)
	TabsContainer.set_tab_icon(3, inventory_icon)
	TabsContainer.set_tab_icon(4, witchers_icon)
	
	for i in range(num_tabs):
		TabsContainer.set_tab_title(i, "")
