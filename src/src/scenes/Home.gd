extends Control

var _entry = false

@onready var _tabs = get_node("TabContainer") as TabContainer
@onready var _num_tabs: int = _tabs.get_child_count()

const _textures := {
	0: preload("res://art/UI/tabs/herbs_potions.png"),
	1: preload("res://art/UI/tabs/minerals_metals.png"),
	2: preload("res://art/UI/tabs/equipment.png"),
	3: preload("res://art/UI/tabs/utility.png"),
}

func _ready():
	_entry = true
	for i in range(_num_tabs):
		_tabs.set_tab_icon(i, _textures[i])
		_tabs.set_tab_title(i, "")


func _on_herbs_visibility_changed():
	if visible and _entry:
		await ScenesTrans.change_tab($TabContainer/Herbs, Items.data["arenaria"]["sprite"])


func _on_metals_visibility_changed():
	if visible:
		await ScenesTrans.change_tab($TabContainer/Metals, Items.data["arenaria"]["sprite"])


func _on_equipment_visibility_changed():
	if visible:
		await ScenesTrans.change_tab($TabContainer/Equipment, Items.data["arenaria"]["sprite"])


func _on_utility_visibility_changed():
	if visible:
		await ScenesTrans.change_tab($TabContainer/Utility, Items.data["arenaria"]["sprite"])
