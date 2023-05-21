extends "res://src/scenes/buttons/Clickable.gd"

var _requirements: Dictionary

@onready var _req_container: HBoxContainer = get_node("Description/R")

@onready var _req_pair := preload("res://src/scenes/buttons/ReqPair.tscn")


func _ready():
	Events.update_qty.connect(_update_requirements)
	Events.set_qty.connect(_validate)
	_item.item_name = _name
	_requirements = Items.data[_name]["requirements"]
	_validate()
	_hide_description()
	_set_description()

func _set_description():
	_name_label.text = _name.capitalize().replace("_", " ")
	_power_label.text = str(Items.data[_name]["power"])
	
	for item in _requirements.keys():
		var pair = _req_pair.instantiate()
		_req_container.add_child(pair)
		pair.get_node("Qty").text = str(_requirements[item])
		pair.get_node("Item").texture = Items.data[item]["sprite"]


func _validate():
	var is_valid = true
	for item in _requirements.keys():
		var dict = Items.qty
		if item == "hunter" or item == "master":
			if Items.stats[item + "s"] < _requirements[item]:
				is_valid = false
		elif dict[item] < _requirements[item]:
			is_valid = false
	disabled = not is_valid

func _update_requirements(_item: String, _qty_delta: int):
	_validate()

func _on_pressed():
	Events.emit_signal("update_qty", _name, 1)
	for req_name in _requirements.keys():
		Events.emit_signal("update_qty", req_name, - _requirements[req_name])
	_validate()
	_rotate()
	_emit_particles()
