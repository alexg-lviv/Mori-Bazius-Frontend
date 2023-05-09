extends Node

# TODO
var _url: String

var _GET = HTTPRequest.new()
var _POST = HTTPRequest.new()


signal update_qty(item: String, qty_delta: int)

signal update_exp(exp_delta: int)

signal set_qty()

signal save()

signal pull()


func _ready():
	update_qty.connect(_update_qty)
	update_exp.connect(_update_exp)
	
	save.connect(_on_save)
	pull.connect(_on_pull)
	
	_POST.request_completed.connect(_on_post_request_completed)
	_GET.request_completed.connect(_on_get_request_completed)


func _update_exp(exp_delta: int):
	Items.stats["exp"] += exp_delta
	Items.stats["level"] = floori(Items.stats["exp"] / 10) + 1
	Items.stats["power"] = Items.power * Items.stats["level"]


func _update_qty(item: String, qty_delta: int):
	if item == "hunter" or item == "master":
		Items.stats[item + "s"] += qty_delta
	else:
		Items.qty[item] += qty_delta
	Items.power += qty_delta * Items.data[item]["power"]
	Items.stats["power"] = Items.power * Items.stats["level"]


func _on_save():
	print("Save emitted")
#	var err = _POST.request(
#		#TODO: player id
#		_url,
#		["Content-Type: application/json"],
#		HTTPClient.METHOD_POST,
#		JSON.stringify(Items.qty)
#	)
	# TODO: error checks

func _on_pull():
	print("Load emitted")
#	var err = _GET.request(
#		#TODO: player id
#		_url,
#	)
	# TODO: error checks
	
	for item in Items.qty:
		Items.power += Items.qty[item] * Items.data[item]["power"]
	Items.power += Items.stats["hunters"] * Items.data["hunter"]["power"]
	Items.power += Items.stats["masters"] * Items.data["master"]["power"]
	
	Items.stats["power"] = Items.power * Items.stats["level"]
	
	emit_signal("set_qty")


func _on_post_request_completed(result, response_code, headers, body):
	# TODO: error checks
	pass

func _on_get_request_completed(result, response_code, headers, body):
	# TODO: error checks
	var res = JSON.parse_string(body.get_string_from_utf8())
	if res:
		Items.qty = res
	else:
		# TODO: jsonification error
		pass
