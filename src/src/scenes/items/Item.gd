extends TextureRect

class_name Item

@export var item_name: String:
	set(value):
		if not value.is_empty():
			item_name = value
			set_texture(Items.data[item_name]["sprite"])
