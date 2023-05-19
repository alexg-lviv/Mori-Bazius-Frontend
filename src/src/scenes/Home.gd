extends Control

@onready var _craftables := get_node("Craftables").get_children()

# TODO: remove
@onready var _text = $ItemsText


func _ready():
	_text.text = str(Items.stats["power"]) + "\n" + str(Items.qty)
	
	Events.update_qty.connect(_update_label)
	Events.update_qty.connect(_update_requirements)


func _update_label(item: String, _qty_delta: int):
	# TODO: change only item's label, and not all 
	_text.text = "total power: " + str(Items.stats["power"]) + "\n" + str(Items.qty)

func _update_requirements(item: String, _qty_delta: int):
	# TODO: update only for items with dirrect requirements of item
	for i in _craftables:
		i.validate()
