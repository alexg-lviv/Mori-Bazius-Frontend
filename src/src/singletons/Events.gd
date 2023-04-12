extends Node

signal update_qty(item: String, qty_delta: int)

signal save()

func _ready():
	update_qty.connect(_update_qty)
	save.connect(_print_on_save)

func _update_qty(item: String, qty_delta: int):
	Items.qty[item] += qty_delta
	Stats.power += qty_delta * Items.power[item]

func _print_on_save():
	print("Save emitted")
