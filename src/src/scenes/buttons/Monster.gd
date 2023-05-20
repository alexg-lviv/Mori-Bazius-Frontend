extends Control


@export var monster_name: String:
	set(value):
		if not value.is_empty():
			monster_name = value
			get_node("Monster/TextureRect").set_texture(Items.monsters[monster_name]["sprite"])
			_hunter_p = Items.monsters[monster_name]["hunter_p"]
			_master_p = Items.monsters[monster_name]["master_p"]
			_exp = Items.monsters[monster_name]["exp"]
			get_node("Description/Label").text = monster_name.capitalize()
			get_node("Description/Stats/Exp/Label").text = str(_exp)
			get_node("Description/Stats/Probs/VBoxContainer/Hunter/Label").text = str(_hunter_p)
			get_node("Description/Stats/Probs/VBoxContainer/Master/Label").text = str(_master_p)
			

var _hunter_p: float
var _master_p: float
var _exp: int

@onready var _monster = get_node("Monster") as TextureButton
@onready var _hunter = get_node("Hunter") as TextureButton
@onready var _master = get_node("Master") as TextureButton

@onready var _hunters_logs = get_node("HuntersLogs") as VBoxContainer
@onready var _masters_logs = get_node("MastersLogs") as VBoxContainer

@onready var _description = get_node("Description") as VBoxContainer


func _ready():
	_description.visible = false
	Events.update_qty.connect(_validate)
	_validate("", 0)

func _validate(_item: String, _qty_delta: int):
	_hunter.disabled = true if Items.stats["hunters"] == 0 else false
	_master.disabled = true if Items.stats["masters"] == 0 else false
	_monster.disabled = true if _hunter.disabled and _master.disabled else false
	

func _on_hunter_pressed():
	if randf_range(0, 1) <= _hunter_p:
		_display_log(_hunters_logs, "\nHunter died fighting " + monster_name)
		Events.emit_signal("update_qty", "hunter", -1)
	else:
		_display_log(_hunters_logs, "\nHunter slayed " + monster_name)
		Events.emit_signal("update_exp", _exp)

func _on_master_pressed():
	if randf_range(0, 1) <= _master_p:
		_display_log(_masters_logs, "\nMaster died fighting " + monster_name)
		Events.emit_signal("update_qty", "master", -1)
	else:
		_display_log(_masters_logs, "\nMaster slayed " + monster_name)
		Events.emit_signal("update_exp", _exp)

func _display_log(logs_container: VBoxContainer, line: String):
	var timer := Timer.new()
	var label := Label.new()
	add_child(timer)
	logs_container.add_child(label)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT if logs_container == _hunters_logs else HORIZONTAL_ALIGNMENT_LEFT
	timer.wait_time = 1.5
	label.text = line
	timer.timeout.connect(_delete_log.bind(timer, label))
	timer.start()

func _delete_log(timer: Timer, label: Label):
	var tween = create_tween()
	tween.tween_property(label, "modulate", Color.TRANSPARENT, 0.5)
	tween.tween_callback(label.queue_free)
	timer.queue_free()


func _scale_up(butt: TextureButton):
	var tween = get_tree().create_tween()
	tween.tween_property(butt, "scale", 1.3 * Vector2.ONE, 0.05).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

func _scale_down(butt: TextureButton):
	var tween = get_tree().create_tween()
	tween.tween_property(butt, "scale", Vector2.ONE, 0.05).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)


func _on_monster_mouse_entered():
	_description.visible = true

func _on_monster_mouse_exited():
	_description.visible = false


func _on_hunter_mouse_entered():
	_scale_up(_hunter)
	_scale_up(_monster)

func _on_hunter_mouse_exited():
	_scale_down(_hunter)
	_scale_down(_monster)


func _on_master_mouse_entered():
	_scale_up(_master)
	_scale_up(_monster)

func _on_master_mouse_exited():
	_scale_down(_master)
	_scale_down(_monster)
