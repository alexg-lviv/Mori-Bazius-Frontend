extends Control

var home_icon = preload("res://icon.svg")
var inventory_icon = preload("res://icon.svg")
var monsters_icon = preload("res://icon.svg")
var leaderboard_icon = preload("res://icon.svg")

var num_tabs = 4

@onready var TabsContainer = get_node("TabContainer")


func _ready():
	TabsContainer.set_tab_icon(0, home_icon)
	TabsContainer.set_tab_icon(1, inventory_icon)
	TabsContainer.set_tab_icon(2, monsters_icon)
	TabsContainer.set_tab_icon(3, leaderboard_icon)
	
	for i in range(num_tabs):
		TabsContainer.set_tab_title(i, "")
		
#	Events.emit_signal("pull")  # TODO: uncomment

func _on_save_timer_timeout():
	Events.emit_signal("save")
