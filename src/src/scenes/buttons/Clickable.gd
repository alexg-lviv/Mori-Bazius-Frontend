extends TextureButton

@export var _name: String
@onready var _item: Item = get_node("Item")

@onready var _description: VBoxContainer = get_node("Description")
@onready var _name_label: Label = _description.get_node("ItemName")
@onready var _power_label: Label = _description.get_node("Power/ItemPower")

var _rot_tween

func _ready():
	_item.item_name = _name
	_hide_description()
	_set_description()

func _set_description():
	_name_label.text = _name.capitalize().replace("_", " ")
	_power_label.text = str(Items.data[_name]["power"])

func _hide_description():
	_description.visible = false

func _show_description():
	_description.visible = true

func _on_pressed():
	Events.emit_signal("update_qty", _name, 1)
	if _rot_tween and _rot_tween.is_running():
		return

	_rot_tween = get_tree().create_tween()
	_rot_tween.tween_property(self, "rotation_degrees", pow(-1, randi()) * randf_range(5, 30), 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	_rot_tween.tween_property(self, "rotation_degrees", 0, 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN).set_delay(0.1)

func _on_mouse_entered():
	_show_description()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", 1.2 * Vector2.ONE, 0.05).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

func _on_mouse_exited():
	_hide_description()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.05).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
