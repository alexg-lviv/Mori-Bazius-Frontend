extends TextureButton

@export var _name: String
@onready var _item: Item = get_node("Item")

@onready var _description: VBoxContainer = get_node("Description")
@onready var _name_label: Label = _description.get_node("ItemName")
@onready var _power_label: Label = _description.get_node("Power/ItemPower")

@onready var _particles := preload("res://src/scenes/particles/Click.tscn")
@onready var _spawn_position: Node2D = get_node("ParticlesSpawn")

var _rot_tween

func _ready():
	_item.item_name = _name
	_description.visible = false
	_name_label.visible_ratio = 0
	_power_label.visible_ratio = 0
	_set_description()

func _set_description():
	_name_label.text = _name.capitalize().replace("_", " ")
	_power_label.text = str(Items.data[_name]["power"])

func _hide_description():
	var tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.tween_property(_name_label, "visible_ratio", 0, 0.2)
	tween.tween_property(_power_label, "visible_ratio", 0, 0.1)
	await tween.finished
	_description.visible = false

func _show_description():
	_description.visible = true
	var tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.tween_property(_name_label, "visible_ratio", 1, 0.2)
	tween.tween_property(_power_label, "visible_ratio", 1, 0.1)

func _on_pressed():
	Events.emit_signal("update_qty", _name, 1)
	_rotate()
	_emit_particles()
	

func _on_mouse_entered():
	_show_description()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", 1.2 * Vector2.ONE, 0.05).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

func _on_mouse_exited():
	_hide_description()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.05).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

func _rotate():
	if _rot_tween and _rot_tween.is_running():
		return

	_rot_tween = get_tree().create_tween()
	_rot_tween.tween_property(self, "rotation_degrees", pow(-1, randi()) * randf_range(5, 20), 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	_rot_tween.tween_property(self, "rotation_degrees", 0, 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN).set_delay(0.1)

func _emit_particles():
	var p = _particles.instantiate()
	_spawn_position.add_child(p)
	p.texture = _item.texture
	p.emit_and_free()
