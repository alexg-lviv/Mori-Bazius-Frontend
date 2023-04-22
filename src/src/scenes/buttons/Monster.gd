extends Control


@export var monster_name: String:
	set(value):
		if not value.is_empty():
			monster_name = value
			get_node("Monster/TextureRect").set_texture(Items.monsters[monster_name]["sprite"])
			_hunter_p = Items.monsters[monster_name]["hunter_p"]
			_master_p = Items.monsters[monster_name]["master_p"]
			_exp = Items.monsters[monster_name]["exp"]
			

var _hunter_p: float
var _master_p: float
var _exp: int

@onready var _hunter = get_node("Hunter") as TextureButton
@onready var _master = get_node("Master") as TextureButton
@onready var _logs = get_node("Monster/Label") as Label
@onready var _timer = get_node("Timer") as Timer


func _ready():
	Events.update_qty.connect(_validate)

func _validate(_item: String, _qty_delta: int):
	_hunter.disabled = true if Items.hunters["hunter"] == 0 else false
	_master.disabled = true if Items.hunters["master"] == 0 else false

func _on_hunter_pressed():
	if randf_range(0, 1) <= _hunter_p:
		_logs.text += "Hunter died fighting " + monster_name
		Events.emit_signal("update_qty", "hunter", -1)
	else:
		Events.emit_signal("update_exp", _exp)

func _on_master_pressed():
	if randf_range(0, 1) <= _master_p:
		_logs.text += "Master died fighting " + monster_name
		Events.emit_signal("update_qty", "master", -1)
	else:
		Events.emit_signal("update_exp", _exp)
