extends TextureRect

func set_player_data(i: int, player_name: String):
	$HBoxContainer/Num.text = str(i)
	$HBoxContainer/Name.text = player_name
