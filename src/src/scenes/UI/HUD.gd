extends Control

@onready var _power_label: Label = get_node("UpperPanel/HBoxContainer/Power/Label")
@onready var _level_label: Label = get_node("UpperPanel/HBoxContainer/Level/Label")
@onready var _hunters_label: Label = get_node("UpperPanel/HBoxContainer/Hunters/Label")
@onready var _masters_label: Label = get_node("UpperPanel/HBoxContainer/Masters/Label")

func _ready():
	Events.update_qty.connect(_update_power)
	Events.update_exp.connect(_update_level)
	Events.set_qty.connect(_set_labels)

func _update_power(_item: String, _qty_delta: int):
	_power_label.text = str(Items.stats["power"])
	_hunters_label.text = str(Items.stats["hunters"])
	_masters_label.text = str(Items.stats["masters"])

func _update_level(_exp_delta: int):
	_power_label.text = str(Items.stats["power"])
	_level_label.text = str(Items.stats["level"])

func _set_labels():
	_update_power("", 0)
	_update_level(0)
