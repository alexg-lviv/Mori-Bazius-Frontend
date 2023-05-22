extends Control


@export var monster_name: String:
	set(value):
		if not value.is_empty():
			monster_name = value
			get_node("Monster/TextureRect").set_texture(Items.monsters[monster_name]["sprite"])
			_hunter_p = Items.monsters[monster_name]["hunter_p"]
			_master_p = Items.monsters[monster_name]["master_p"]
			_exp = Items.monsters[monster_name]["exp"]
			get_node("Description/Label").text = monster_name.capitalize()
			get_node("Description/Exp/Label").text = str(_exp)
			get_node("Hunter/WR/Label").text = str(100 * (1 - _hunter_p)) + "%"
			get_node("Master/WR/Label").text = str(100 * (1 - _master_p)) + "%"


var _hunter_p: float
var _master_p: float
var _exp: int

var _rot_tween_hunter
var _rot_tween_master


@onready var _monster = get_node("Monster") as TextureButton
@onready var _hunter = get_node("Hunter") as TextureButton
@onready var _master = get_node("Master") as TextureButton

@onready var _description = get_node("Description") as VBoxContainer

@onready var _hunters_wr = get_node("Hunter/WR") as HBoxContainer
@onready var _masters_wr = get_node("Master/WR") as HBoxContainer

@onready var _spawn_hunters = get_node("Hunter/ParticlesSpawn") as Node2D
@onready var _spawn_masters = get_node("Master/ParticlesSpawn") as Node2D

@onready var _particles := preload("res://src/scenes/particles/Click.tscn")

@onready var _hunter_death_anim = get_node("Hunter/AnimatedSprite2D")
@onready var _master_death_anim = get_node("Master/AnimatedSprite2D")
@onready var _monster_death_anim = get_node("Monster/AnimatedSprite2D")


func _ready():
	$Hunter/Smoke.visible = false
	$Master/Smoke.visible = false
	_hunters_wr.visible = false
	_masters_wr.visible = false
	_description.visible = false
	_hunter_death_anim.visible = false
	_master_death_anim.visible = false
	_monster_death_anim.visible = false
	Events.update_qty.connect(_validate)
	Events.set_qty.connect(_val)
	_validate("", 0)

func _validate(_item: String, _qty_delta: int):
	_val()

func _val():
	_hunter.disabled = true if Items.stats["hunters"] == 0 else false
	_master.disabled = true if Items.stats["masters"] == 0 else false
	_monster.disabled = true if _hunter.disabled and _master.disabled else false

func _play_death_anim(sprite: AnimatedSprite2D):
	sprite.visible = true
	sprite.play("default")
	await sprite.animation_finished
	sprite.visible = false

func _play_smoke_anim(sprite: AnimatedSprite2D):
	sprite.visible = true
	sprite.play_backwards("default")
	await sprite.animation_finished
	sprite.visible = false

func _on_hunter_pressed():
	_play_smoke_anim($Hunter/Smoke)
	_rotate(_hunter, _rot_tween_hunter)
	_emit_fight_particles(Items.data["silver_sword"]["sprite"])
	
	if randf_range(0, 1) <= _hunter_p:
		_play_death_anim(_hunter_death_anim)
		Events.emit_signal("update_qty", "hunter", -1)
	else:
		_play_death_anim(_monster_death_anim)
		Events.emit_signal("update_exp", _exp)


func _on_master_pressed():
	_play_smoke_anim($Master/Smoke)
	_rotate(_master, _rot_tween_master)
	_emit_fight_particles(Items.data["kingslayers_silver_sword"]["sprite"])
	
	if randf_range(0, 1) <= _master_p:
		_play_death_anim(_master_death_anim)
		Events.emit_signal("update_qty", "master", -1)
	else:
		_play_death_anim(_monster_death_anim)
		Events.emit_signal("update_exp", _exp)

func _scale_up(butt: TextureButton):
	var tween = get_tree().create_tween()
	tween.tween_property(butt, "scale", 1.3 * Vector2.ONE, 0.05).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

func _scale_down(butt: TextureButton):
	var tween = get_tree().create_tween()
	tween.tween_property(butt, "scale", Vector2.ONE, 0.05).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

func _rotate(butt: TextureButton, tween):
	if tween and tween.is_running():
		return

	tween = get_tree().create_tween()
	tween.tween_property(butt, "rotation_degrees", pow(-1, randi()) * randf_range(5, 30), 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.tween_property(butt, "rotation_degrees", 0, 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN).set_delay(0.1)


func _on_monster_mouse_entered():
	_description.visible = true
	_hunters_wr.visible = true
	_masters_wr.visible = true
	_scale_up(_hunter)
	_scale_up(_master)
	_scale_up(_monster)

func _on_monster_mouse_exited():
	_description.visible = false
	_hunters_wr.visible = false
	_masters_wr.visible = false
	_scale_down(_hunter)
	_scale_down(_master)
	_scale_down(_monster)


func _on_hunter_mouse_entered():
	_description.visible = true
	_hunters_wr.visible = true
	_scale_up(_hunter)
	_scale_up(_monster)

func _on_hunter_mouse_exited():
	_description.visible = false
	_hunters_wr.visible = false
	_scale_down(_hunter)
	_scale_down(_monster)


func _on_master_mouse_entered():
	_description.visible = true
	_masters_wr.visible = true
	_scale_up(_master)
	_scale_up(_monster)

func _on_master_mouse_exited():
	_description.visible = false
	_masters_wr.visible = false
	_scale_down(_master)
	_scale_down(_monster)


func _emit_fight_particles(texture):
	var p = _particles.instantiate()
	$Monster/ParticlesSpawn.add_child(p)
	p.texture = texture
	p.emit_and_free()
