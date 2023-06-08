extends Control

@onready var _leaves = preload("res://src/scenes/particles/Leaves.tscn")
@onready var _tabs = preload("res://src/scenes/particles/Tabs.tscn")

enum TransitionType {FADE, LEAVES}

func change_scene(target: Node, type: TransitionType):
	if type == TransitionType.FADE:
		await _fade(target)
	elif type == TransitionType.LEAVES:
		await _emit_leaves(target)


func _fade(target):
	var tween = create_tween()
	tween.tween_property($CanvasLayer/ColorRect, "modulate", Color.WHITE, 0.25)
	await tween.finished
	tween.stop()
	get_tree().get_root().add_child(target)
	tween.tween_property($CanvasLayer/ColorRect, "modulate", Color.TRANSPARENT, 0.25)
	tween.play()


func _emit_leaves(target):
	var p = _leaves.instantiate()
	$CanvasLayer.add_child(p)
	p.emitting = true
	get_tree().get_root().add_child(target)
	
	var tween = create_tween()
	tween.tween_property(target, "position", Vector2.ZERO, 1.25).from(Vector2(0, -1280)).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	await get_tree().create_timer(1.25).timeout
	
	p.queue_free()

func change_tab(target, texture):
	var p = _tabs.instantiate()
	$CanvasLayer.add_child(p)
	p.texture = texture
	p.emitting = true
	
	var tween = create_tween().set_parallel()
	tween.tween_property(target.get_node("TextureRect"), "position", target.get_node("TextureRect").position, 0.5).from(Vector2(0, -200)).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(target.get_node("Shadow"), "position", target.get_node("Shadow").position, 0.5).from(Vector2(0, -200)).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(target.get_node("Control"), "position", target.get_node("Control").position, 0.5).from(Vector2(0, 2 * 1280)).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)

	await get_tree().create_timer(0.5).timeout
	p.queue_free()


func change_main_tab(target, texture, from_vec):
	var p = _tabs.instantiate()
	$CanvasLayer.add_child(p)
	p.texture = texture
	p.emitting = true
	
	var tween = create_tween().set_parallel()
	tween.tween_property(target, "position", target.position, 0.5).from(from_vec).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)

	await get_tree().create_timer(0.5).timeout
	p.queue_free()
