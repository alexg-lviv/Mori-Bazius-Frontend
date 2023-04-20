extends TextureButton

@export var _name: String
@onready var _item: Item = get_node("Item")

func _ready():
	_item.item_name = _name

func _on_pressed():
	Events.emit_signal("update_qty", _name, 1)
