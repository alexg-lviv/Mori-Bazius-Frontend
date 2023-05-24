extends Control

enum TransitionType {FADE, LEAVES}

func change_scene(target, type: TransitionType):
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
	$CanvasLayer/GPUParticles2D.emitting = true
	get_tree().get_root().add_child(target)
	var tween = create_tween()
	tween.tween_property(target, "position", Vector2.ZERO, 1.25).from(Vector2(0, -1280)).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	await get_tree().create_timer(1.25).timeout
