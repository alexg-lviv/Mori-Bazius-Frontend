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
		"power": 30,
		"sprite": preload("res://art/items/craftable/potions/swallow.png"),
		"requirements": {
			"arenaria": 10,
			"nostrix": 5,
			"wolfsbane": 5,
		},
	},

	"meteorite_silver_ore": {
		"power": 2,
		"sprite": preload("res://art/items/clickable/ores/meteorite_silver_ore.png"),
		"requirements": null,
	},
	"dark_steel_ore": {
		"power": 2,
		"sprite": preload("res://art/items/clickable/ores/dark_steel_ore.png"),
		"requirements": null,
	},
	"green_gold_ore": {
		"power": 3,
		"sprite": preload("res://art/items/clickable/ores/green_gold_ore.png"),
		"requirements": null,
	},

	"meteorite_silver_ingot": {
		"power": 30,
		"sprite": preload("res://art/items/craftable/ingots/meteorite_silver_ingot.png"),
		"requirements": {
			"meteorite_silver_ore": 10,
		},
	},
	"dark_steel_ingot": {
		"power": 30,
		"sprite": preload("res://art/items/craftable/ingots/dark_steel_ingot.png"),
		"requirements": {
			"dark_steel_ore": 10,
		},
	},
	"green_gold_ingot": {
		"power": 45,
		"sprite": preload("res://art/items/craftable/ingots/green_gold_ingot.png"),
		"requirements": {
			"green_gold_ore": 10,
		},
	},

	"diamond_dust": {
		"power": 5,
		"sprite": preload("res://art/items/clickable/other/diamond_dust.png"),
		"requirements": null,
	},
	"diamond": {
		"power": 100,
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
		"power": 1,
		"sprite": preload("res://art/items/clickable/other/leather_scrap.png"),
		"requirements": null,
	},
	"oil": {
		"power": 1,
		"sprite": preload("res://art/items/clickable/other/oil.png"),
		"requirements": null,
	},

	"armor": {
		"power": 180,
		"sprite": preload("res://art/items/craftable/armor/armor.png"),
		"requirements": {
			"dark_steel_ingot": 1,
			"leather_scraps": 50,
			"monster_bone": 10,
		},
	},
	"mastercrafted_armor": {
		"power": 750,
		"sprite": preload("res://art/items/upgrades/armor/mastercrafted_armor.png"),
		"requirements": {
			"diamond": 1,
			"meteorite_silver_ingot": 1,
			"green_gold_ingot": 1,
			"leather_scraps": 10,
			"armor": 1,
		},
	},

	"steel_sword": {
		"power": 210,
		"sprite": preload("res://art/items/craftable/swords/steel_sword.png"),
		"requirements": {
			"dark_steel_ingot": 3,
			"oil": 10,
			"leather_scraps": 5,
		},
	},
	"kingslayers_steel_sword": {
		"power": 950,
		"sprite": preload("res://art/items/upgrades/swords/kingslayers_steel_sword.png"),
		"requirements": {
			"diamond": 1,
			"green_gold_ingot": 5,
			"steel_sword": 1,
		},
	},

	"silver_sword": {
		"power": 210,
		"sprite": preload("res://art/items/craftable/swords/silver_sword.png"),
		"requirements": {
			"meteorite_silver_ingot": 3,
			"oil": 10,
			"leather_scraps": 5,
		},
	},
	"kingslayers_silver_sword": {
		"power": 950,
		"sprite": preload("res://art/items/upgrades/swords/kingslayers_silver_sword.png"),
		"requirements": {
			"diamond": 1,
			"green_gold_ingot": 5,
			"silver_sword": 1,
		},
	},
	
	"hunter": {
		"power": 1500,
		"sprite": preload("res://art/hunters/hunter.png"),
		"requirements": {
			"swallow_potion": 5,
			"silver_sword": 1,
			"steel_sword": 1,
			"armor": 1,
		},
	},

	"master": {
		"power": 8900,
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
	"arenaria": 10,
	"nostrix": 10,
	"wolfsbane": 10,
	
	"swallow_potion": 15,
	
	"meteorite_silver_ore": 0,
	"dark_steel_ore": 0,
	"green_gold_ore": 0,
	
	"meteorite_silver_ingot": 5,
	"dark_steel_ingot": 5,
	"green_gold_ingot": 5,
	
	"diamond_dust": 0,
	"diamond": 10,
	
	"monster_bone": 0,
	"leather_scraps": 0,
	"oil": 0,
	
	"armor": 1,
	"mastercrafted_armor": 0,
	
	"steel_sword": 1,
	"kingslayers_steel_sword": 0,
	
	"silver_sword": 1,
	"kingslayers_silver_sword": 0,
}

var stats: Dictionary = {
	"power": 0,
	"level": 1,
	"hunters": 3,
	"masters": 1,
	"exp": 0,
}

var credentials: Dictionary = {
	"player_id": null,
	"token": null,
	"player_name": null,
}
