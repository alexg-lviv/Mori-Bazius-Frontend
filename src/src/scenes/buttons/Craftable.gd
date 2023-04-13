extends "res://src/scenes/buttons/Clickable.gd"

var _requirements: Dictionary

func _ready():
	_item.item_name = _name
	_requirements = Items.data[_name]["requirements"]
	validate()

func validate():
	var is_valid = true
	for item in _requirements.keys():
		if Items.qty[item] < _requirements[item]:
			is_valid = false
	disabled = not is_valid

func _on_pressed():
	Events.emit_signal("update_qty", _name, 1)
	for req_name in _requirements.keys():
		Events.emit_signal("update_qty", req_name, - _requirements[req_name])
	validate()
