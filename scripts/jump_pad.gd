extends Node2D

func _on_jump_body_entered(body: Node2D) -> void:
	if body is Player:
		GlobalVariables.on_jump_pad = true
