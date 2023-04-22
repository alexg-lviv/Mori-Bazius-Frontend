extends Node

var player_id: int

var power: int = 100
var exp: int = 0
var lvl: int = 0


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
		"sprite": preload("res://art/items/clickable/ores/meteorite_silver_ore.png"),
		"requirements": null,
	},
	"dark_steel_ore": {
		"power": 5,
		"sprite": preload("res://art/items/clickable/ores/dark_steel_ore.png"),
		"requirements": null,
	},
	"green_gold_ore": {
		"power": 5,
		"sprite": preload("res://art/items/clickable/ores/green_gold_ore.png"),
		"requirements": null,
	},

	"meteorite_silver_ingot": {
		"power": 100,
		"sprite": preload("res://art/items/craftable/ingots/meteorite_silver_ingot.png"),
		"requirements": {
			"meteorite_silver_ore": 10,
		},
	},
	"dark_steel_ingot": {
		"power": 100,
		"sprite": preload("res://art/items/craftable/ingots/dark_steel_ingot.png"),
		"requirements": {
			"dark_steel_ore": 10,
		},
	},
	"green_gold_ingot": {
		"power": 100,
		"sprite": preload("res://art/items/craftable/ingots/green_gold_ingot.png"),
		"requirements": {
			"green_gold_ore": 10,
		},
	},

	"diamond_dust": {
		"power": 2,
		"sprite": preload("res://art/items/clickable/other/diamond_dust.png"),
		"requirements": null,
	},
	"diamond": {
		"power": 50,
		"sprite": preload("res://art/items/craftable/other/diamond.png"),
		"requirements": {
			"diamond_dust": 10,
		},
	},

	"monster_bone": {
		"power": 1,
		"sprite": preload("res://art/items/clickable/monsters_loot/monster_bone.png"),
		"requirements": null,
	},
	"leather_scraps": {
		"power": 3,
		"sprite": preload("res://art/items/clickable/other/leather_scrap.png"),
		"requirements": null,
	},
	"oil": {
		"power": 1,
		"sprite": preload("res://art/items/clickable/other/oil.png"),
		"requirements": null,
	},

	"armor": {
		"power": 350,
		"sprite": preload("res://art/items/craftable/armor/armor.png"),
		"requirements": {
			"dark_steel_ingot": 1,
			"leather_scraps": 20,
			"monster_bone": 5,
		},
	},
	"mastercrafted_armor": {
		"power": 2500,
		"sprite": preload("res://art/items/upgrades/armor/mastercrafted_armor.png"),
		"requirements": {
			"diamond": 5,
			"meteorite_silver_ingot": 3,
			"green_gold_ingot": 3,
			"leather_scraps": 10,
			"armor": 1
		},
	},

	"steel_sword": {
		"power": 550,
		"sprite": preload("res://art/items/craftable/swords/steel_sword.png"),
		"requirements": {
			"dark_steel_ingot": 2,
			"oil": 8,
			"leather_scraps": 4,
		},
	},
	"kingslayers_steel_sword": {
		"power": 3500,
		"sprite": preload("res://art/items/upgrades/swords/kingslayers_steel_sword.png"),
		"requirements": {
			"diamond": 5,
			"green_gold_ingot": 5,
			"steel_sword": 1,
		},
	},

	"silver_sword": {
		"power": 550,
		"sprite": preload("res://art/items/craftable/swords/silver_sword.png"),
		"requirements": {
			"meteorite_silver_ingot": 2,
			"oil": 8,
			"leather_scraps": 4,
		},
	},
	"kingslayers_silver_sword": {
		"power": 3500,
		"sprite": preload("res://art/items/upgrades/swords/kingslayers_silver_sword.png"),
		"requirements": {
			"diamond": 5,
			"green_gold_ingot": 5,
			"silver_sword": 1,
		},
	},
	
	"hunter": {
		"power": 10000, # TODO,
		"sprite": preload("res://art/hunters/hunter.png"),
		"requirements": {
			"swallow_potion": 10,
			"silver_sword": 1,
			"steel_sword": 1,
			"armor": 1,
		},
	},

	"master": {
		"power": 100000, # TODO,
		"sprite": preload("res://art/hunters/master.png"),
		"requirements": {
			"hunter": 1,
			"swallow_potion": 10,
			"silver_sword": 1,
			"steel_sword": 1,
			"armor": 1,
		},
	},
}

const monsters: Dictionary = {
	"bruxa": {
		"exp": 1,
		"sprite": preload("res://art/monsters/bruxa.png"),
		"hunter_p": 0.1,
		"master_p": 0.05,
	},
	"kikimora": {
		"exp": 3,
		"sprite": preload("res://art/monsters/kikimora.png"),
		"hunter_p": 0.2,
		"master_p": 0.1,
	},
	"wyvern": {
		"exp": 15,
		"sprite": preload("res://art/monsters/wyvern.png"),
		"hunter_p": 0.5,
		"master_p": 0.25,
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

var hunters: Dictionary = {
	"hunter": 5,
	"master": 5,
}
