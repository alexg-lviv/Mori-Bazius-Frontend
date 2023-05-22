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
	_set_description()
	_description.visible = false
	_name_label.visible_ratio = 0
	_power_label.visible_ratio = 0
	for child in _req_container.get_children():
		child.get_node("Qty").visible_ratio = 0

func _set_description():
	_name_label.text = _name.capitalize().replace("_", " ")
	_power_label.text = str(Items.data[_name]["power"])
	
	for item in _requirements.keys():
		var pair = _req_pair.instantiate()
		_req_container.add_child(pair)
		pair.get_node("Qty").text = str(_requirements[item])
		pair.get_node("Item").texture = Items.data[item]["sprite"]

func _hide_description():
	var tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.tween_property(_name_label, "visible_ratio", 0, 0.2)
	tween.tween_property(_power_label, "visible_ratio", 0, 0.1)
	for child in _req_container.get_children():
		tween.tween_property(child.get_node("Qty"), "visible_ratio", 0, 0.2)
	await tween.finished
	_description.visible = false

func _show_description():
	_description.visible = true
	var tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.tween_property(_name_label, "visible_ratio", 1, 0.2)
	tween.tween_property(_power_label, "visible_ratio", 1, 0.1)
	for child in _req_container.get_children():
		tween.tween_property(child.get_node("Qty"), "visible_ratio", 1, 0.2)

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
