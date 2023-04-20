extends "res://src/scenes/items/Item.gd"

@onready var _label: Label = get_node("Label")

func _ready():
	_label.text = str(Items.qty[item_name])
	Events.update_qty.connect(_update_label)

func _update_label(item, qty):
	_label.text = str(Items.qty[item_name])
