extends "res://src/scenes/buttons/Clickable.gd"

var _requirements: Dictionary

@onready var _requirements_label: Label = get_node("Description/Requirements")

func _ready():
	_item.item_name = _name
	_requirements = Items.data[_name]["requirements"]
	validate()
	_hide_description()
	_set_description()

func _set_description():
	_name_label.text = _name.capitalize().replace("_", " ")
	_power_label.text = str(Items.data[_name]["power"])
	
	var requirements_str = ""
	for item in _requirements.keys():
		var qty = _requirements[item]
		requirements_str += str(qty) + " x " + item.capitalize().replace("_", " ") + "\n"
	
	_requirements_label.text = requirements_str

func validate():
	var is_valid = true
	for item in _requirements.keys():
		var dict = Items.qty
		if item == "hunter" or item == "master":
			if Items.stats[item + "s"] < _requirements[item]:
				is_valid = false
		elif dict[item] < _requirements[item]:
			is_valid = false
	disabled = not is_valid

func _on_pressed():
	Events.emit_signal("update_qty", _name, 1)
	for req_name in _requirements.keys():
		Events.emit_signal("update_qty", req_name, - _requirements[req_name])
	validate()
