extends Control

@onready var _power_label: Label = get_node("UpperPanel/HBoxContainer/Power/Label")
@onready var _hunters_label: Label = get_node("UpperPanel/HBoxContainer/Hunters/Label")
@onready var _masters_label: Label = get_node("UpperPanel/HBoxContainer/Masters/Label")

func _ready():
	Events.update_qty.connect(_update_labels)
	Events.set_qty.connect(_set_labels)

func _update_labels(_item: String, _qty_delta: int):
	_set_labels()

func _set_labels():
	_power_label.text = str(Items.power)
	_hunters_label.text = str(Items.hunters['hunter'])
	_masters_label.text = str(Items.hunters['master'])
