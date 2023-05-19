extends Control


@onready var _tabs = get_node("TabContainer") as TabContainer
@onready var _num_tabs: int = _tabs.get_child_count()

const _textures := {
	0: preload("res://art/UI/tabs/herbs_potions.png"),
	1: preload("res://art/UI/tabs/minerals_metals.png"),
	2: preload("res://art/UI/tabs/equipment.png"),
	3: preload("res://art/UI/tabs/utility.png"),
}

func _ready():
	for i in range(_num_tabs):
		_tabs.set_tab_icon(i, _textures[i])
		_tabs.set_tab_title(i, "")
