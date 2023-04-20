extends Node

var player_id: int

var power := 0

var hunters_qty := 0
var masters_qty := 0

const hunters_requirements: Dictionary = {
	"swallow_potion": 10,
	"silver_sword": 1,
	"steel_sword": 1,
	"armor": 1,
}

const masters_requirements: Dictionary = {
	"swallow_potion": 10,
	"kingslayers_silver_sword": 1,
	"kingslayers_steel_sword": 1,
	"mastercrafted_armor": 1,
}
