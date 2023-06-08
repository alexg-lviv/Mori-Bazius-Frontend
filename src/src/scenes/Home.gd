extends Control

var _entry = false

@onready var _tabs = get_node("TabContainer") as TabContainer
@onready var _num_tabs: int = _tabs.get_child_count()

const _textures := {
	0: preload("res://art/UI/tabs/herbs.png"),
	1: preload("res://art/UI/tabs/minerals.png"),
	2: preload("res://art/UI/tabs/equipment.png"),
	3: preload("res://art/UI/tabs/utility.png"),
}

const _pressed_textures := {
	0: preload("res://art/UI/tabs/herbs_pressed.png"),
	1: preload("res://art/UI/tabs/minerals_pressed.png"),
	2: preload("res://art/UI/tabs/equipment_pressed.png"),
	3: preload("res://art/UI/tabs/utility_pressed.png"),
}

func _ready():
	_entry = true
	for i in range(_num_tabs):
		_tabs.set_tab_icon(i, _textures[i])
		_tabs.set_tab_title(i, "")
	_tabs.set_tab_icon(0, _pressed_textures[0])  # We start from Herbs page, it is active


func _on_herbs_visibility_changed():
	if _tabs:
		if $TabContainer/Herbs.visible:
			_tabs.set_tab_icon(0, _pressed_textures[0])
			if _entry:
				await ScenesTrans.change_tab($TabContainer/Herbs, Items.data["arenaria"]["sprite"])
		else:
			_tabs.set_tab_icon(0, _textures[0])


func _on_metals_visibility_changed():
	if _tabs:
		if $TabContainer/Metals.visible:
			_tabs.set_tab_icon(1, _pressed_textures[1])
			if _entry:
				await ScenesTrans.change_tab($TabContainer/Metals, Items.data["arenaria"]["sprite"])
		else:
			_tabs.set_tab_icon(1, _textures[1])


func _on_equipment_visibility_changed():
	if _tabs:
		if $TabContainer/Equipment.visible:
			_tabs.set_tab_icon(2, _pressed_textures[2])
			if _entry:
				await ScenesTrans.change_tab($TabContainer/Equipment, Items.data["arenaria"]["sprite"])
		else:
			_tabs.set_tab_icon(2, _textures[2])


func _on_utility_visibility_changed():
	if _tabs:
		if $TabContainer/Utility.visible:
			_tabs.set_tab_icon(3, _pressed_textures[3])
			if _entry:
				await ScenesTrans.change_tab($TabContainer/Utility, Items.data["arenaria"]["sprite"])
		else:
			_tabs.set_tab_icon(3, _textures[3])
