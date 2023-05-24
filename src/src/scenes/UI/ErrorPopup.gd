extends Control

@onready var _main_menu = preload("res://src/scenes/Login.tscn").instantiate()

var error:
	set(value):
		get_node("TextureRect/Label").text = value


func _ready():
	var tween = get_tree().create_tween().set_parallel().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property($TextureRect, "scale", Vector2.ONE, 0.4).from(0.3 * Vector2.ONE)
	tween.tween_property($TextureRect, "rotation_degrees", 0, 0.4).from(45)


func _on_texture_button_pressed():	
	var tween = get_tree().create_tween().set_parallel().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property($TextureRect, "scale", Vector2.ZERO, 0.4)
	tween.tween_property($TextureRect, "rotation_degrees", 45, 0.4)
	await tween.finished
	
	get_tree().get_root().add_child(_main_menu)
	get_tree().get_root().get_node("Main").queue_free()
	queue_free()


func _on_texture_button_mouse_entered():
	var tween = get_tree().create_tween()
	tween.tween_property($TextureRect/TextureButton, "scale", 1.15 * Vector2.ONE, 0.05).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)


func _on_texture_button_mouse_exited():
	var tween = get_tree().create_tween()
	tween.tween_property($TextureRect/TextureButton, "scale", Vector2.ONE, 0.05).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
