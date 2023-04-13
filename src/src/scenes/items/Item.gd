extends TextureRect

class_name Item

var item_name: String:
	set(value):
		item_name = value
		set_texture(Items.data[item_name]["sprite"])
