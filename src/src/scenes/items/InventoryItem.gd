extends "res://src/scenes/items/Item.gd"

@onready var _label: Label = get_node("Label")

func _ready():
	_label.text = str(Items.qty[item_name])
	Events.update_qty.connect(_update_label)
	Events.set_qty.connect(_set_label)

func _update_label(_item, _qty):
	_label.text = str(Items.qty[item_name])

func _set_label():
	_label.text = str(Items.qty[item_name])
