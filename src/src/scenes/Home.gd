extends Control


@onready var _tabs = get_node("TabContainer") as TabContainer
@onready var _num_tabs: int = _tabs.get_child_count()

const _icons := {
	0: preload("res://icon.svg"),
	1: preload("res://icon.svg"),
	2: preload("res://icon.svg"),
	3: preload("res://icon.svg"),
}

func _ready():
	for i in range(_num_tabs):
		_tabs.set_tab_icon(i, _icons[i])
		_tabs.set_tab_title(i, "")
