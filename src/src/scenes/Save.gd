extends Button

# TODO: delete this and button

func _on_pressed():
	Events.emit_signal("save")
