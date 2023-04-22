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

@onready var _monster = get_node("Monster") as TextureButton
@onready var _hunter = get_node("Hunter") as TextureButton
@onready var _master = get_node("Master") as TextureButton
@onready var _logs = get_node("Logs") as VBoxContainer


func _ready():
	Events.update_qty.connect(_validate)

func _validate(_item: String, _qty_delta: int):
	_hunter.disabled = true if Items.hunters["hunter"] == 0 else false
	_master.disabled = true if Items.hunters["master"] == 0 else false
	_monster.disabled = true if _hunter.disabled and _master.disabled else false
	

func _on_hunter_pressed():
	if randf_range(0, 1) <= _hunter_p:
		_display_log("\nHunter died fighting " + monster_name)
		Events.emit_signal("update_qty", "hunter", -1)
	else:
		_display_log("\nHunter slayed " + monster_name)
		Events.emit_signal("update_exp", _exp)

func _on_master_pressed():
	if randf_range(0, 1) <= _master_p:
		_display_log("\nMaster died fighting " + monster_name)
		Events.emit_signal("update_qty", "master", -1)
	else:
		_display_log("\nMaster slayed " + monster_name)
		Events.emit_signal("update_exp", _exp)

func _display_log(line: String):
	var timer := Timer.new()
	var label := Label.new()
	add_child(timer)
	_logs.add_child(label)
	timer.wait_time = 2
	label.text = line
	timer.timeout.connect(_delete_log.bind(timer, label))
	timer.start()

func _delete_log(timer: Timer, label: Label):
	label.queue_free()
	timer.queue_free()
