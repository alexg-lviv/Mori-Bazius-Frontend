extends TextureButton

@export var _name: String
var _item: Item

func _ready():
	_item = Items.items[_name].instantiate()
	add_child(_item)
	_center_item()

func _on_pressed():
	Events.emit_signal("update_qty", _name, 1)

func _center_item():
	_item.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	_item.set_anchor_and_offset(SIDE_LEFT, 0, 20)
	_item.set_anchor_and_offset(SIDE_TOP, 0, 20)
	_item.set_anchor_and_offset(SIDE_RIGHT, 1, -20)
	_item.set_anchor_and_offset(SIDE_BOTTOM, 1, -20)
