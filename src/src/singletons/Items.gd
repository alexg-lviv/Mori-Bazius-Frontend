extends Node

const data: Dictionary = {
	"arenaria": {
		"power": 1,
		"sprite": preload("res://art/items/clickable/herbs/arenaria.png"),
		"requirements": null,
	},
	"nostrix": {
		"power": 1,
		"sprite": preload("res://art/items/clickable/herbs/nostrix.png"),
		"requirements": null,
	},
	"wolfsbane": {
		"power": 1,
		"sprite": preload("res://art/items/clickable/herbs/wolfsbane.png"),
		"requirements": null,
	},
	
	"swallow_potion": {
		"power": 25,
		"sprite": preload("res://art/items/craftable/potions/swallow.png"),
		"requirements": {
			"arenaria": 10,
			"nostrix": 5,
			"wolfsbane": 5,
		},
	},
	
	"meteorite_silver_ore": {
		"power": 5,
		"requirements": null,
	},
	"dark_steel_ore": {
		"power": 5,
		"requirements": null,
	},
	"green_gold_ore": {
		"power": 5,
		"requirements": null,
	},
	
	"meteorite_silver_ingot": {
		"power": 100,
	},
	"dark_steel_ingot": {
		"power": 100,
	},
	"green_gold_ingot": {
		"power": 100,
	},
	
	"diamond_dust": {
		"power": 2,
		"requirements": null,
	},
	"diamond": {
		"power": 50,
	},
	
	"monster_bone": {
		"power": 1,
		"requirements": null,
	},
	"leather_scraps": {
		"power": 3,
		"requirements": null,
	},
	"oil": {
		"power": 1,
		"requirements": null,
	},
	
	"armor": {
		"power": 350,
	},
	"mastercrafted_armor": {
		"power": 2500,
	},
	
	"steel_sword": {
		"power": 550,
	},
	"kingslayers_steel_sword": {
		"power": 3500,
	},
	
	"silver_sword": {
		"power": 550,
	},
	"kingslayers_silver_sword": {
		"power": 3500,
	},
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
