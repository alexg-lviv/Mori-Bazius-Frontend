extends Control

@onready var _main_menu = preload("res://src/scenes/Login.tscn").instantiate()

var error:
	set(value):
		get_node("TextureRect/VBoxContainer/Label").text = value

func _on_texture_button_pressed():
	get_tree().get_root().add_child(_main_menu)
