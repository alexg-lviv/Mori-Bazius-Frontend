extends "res://src/scenes/items/Item.gd"

@onready var _label: Label = get_node("Label")

func _ready():
	_label.text = str(Items.qty[item_name])
	Events.update_qty.connect(_update_label)
	Events.set_qty.connect(_set_label)
	Events.display_items_stats.connect(_show_stat)

func _update_label(_item, _qty):
	_label.text = str(Items.qty[item_name])

func _set_label():
	_label.text = str(Items.qty[item_name])

func _show_stat():
	if Items.items_stats.has("avg_growth_" + item_name):
		var s = Items.items_stats["avg_growth_" + item_name]
		if (typeof(s) == TYPE_FLOAT or typeof(s) == TYPE_INT) and s != 0:
			$Stat.text = str(snapped(s, 0.1))
			return
	$Stat.text = "---"
