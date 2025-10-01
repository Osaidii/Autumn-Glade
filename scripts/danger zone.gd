extends Area2D

#Body has entered area
func _on_body_entered(body):
	if body is Player:
		Scenetransition.change_scene()
		await get_tree().create_timer(1.5).timeout
		get_tree().reload_current_scene()
		Scenetransition.end_transition()
