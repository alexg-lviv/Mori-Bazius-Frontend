extends Node


const power: Dictionary = {
	"arenaria": 1,
	"nostrix": 1,
	"wolfsbane": 1,
	
	"swallow_potion": 25,
	
	"meteorite_silver_ore": 5,
	"dark_steel_ore": 5,
	"green_gold_ore": 5,
	
	"meteorite_silver_ingot": 100,
	"dark_steel_ingot": 100,
	"green_gold_ingot": 100,
	
	"diamond_dust": 2,
	"diamond": 50,
	
	"monster_bone": 1,
	"leather_scraps": 3,
	"oil": 1,
	
	"armor": 350,
	"mastercrafted_armor": 2500,
	
	"steel_sword": 550,
	"kingslayers_steel_sword": 3500,
	
	"silver_sword": 550,
	"kingslayers_silver_sword": 3500,
}

var qty: Dictionary = {
	"arenaria": 0,
	"nostrix": 0,
	"wolfsbane": 0,
	
	"swallow_potion": 0,
	
	"meteorite_silver_ore": 0,
	"dark_steel_ore": 0,
	"green_gold_ore": 0,
	
	"meteorite_silver_ingot": 0,
	"dark_steel_ingot": 0,
	"green_gold_ingot": 0,
	
	"diamond_dust": 0,
	"diamond": 0,
	
	"monster_bone": 0,
	"leather_scraps": 0,
	"oil": 0,
	
	"armor": 0,
	"mastercrafted_armor": 0,
	
	"steel_sword": 0,
	"kingslayers_steel_sword": 0,
	
	"silver_sword": 0,
	"kingslayers_silver_sword": 0,
}

const items: Dictionary = {
	"arenaria": preload("res://src/scenes/items/herbs/Arenaria.tscn"),
	"nostrix": preload("res://src/scenes/items/herbs/Nostrix.tscn"),
	"wolfsbane": preload("res://src/scenes/items/herbs/Wolfsbane.tscn"),
	
	"swallow_potion": preload("res://src/scenes/items/potions/SwallowPotion.tscn"),
}

const requirements: Dictionary = {
	"swallow_potion": {
		"arenaria": 10,
		"nostrix": 5,
		"wolfsbane": 5,
	}
}
