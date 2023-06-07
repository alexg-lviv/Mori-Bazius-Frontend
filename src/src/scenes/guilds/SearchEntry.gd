extends TextureButton

signal show_view(dict)


var _dict := {
	"_id": "",
	"name": "",
	"description": "",
	"num_members": 0,
	"limit_members": 20,
}:
	set(new_dict):
		_dict = new_dict
		$HBoxContainer/Title.text = _dict["name"]
		$HBoxContainer/Members.text = str(_dict["num_members"]) + " / " + str(_dict["limit_members"])


func _on_pressed():
	emit_signal("show_view", _dict)
