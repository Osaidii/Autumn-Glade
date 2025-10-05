extends Area2D

@onready var checkpoint_manager: Node = $".."
@onready var respawn_point: Marker2D = $"Respawn Point"

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		GlobalVariables.at_checkpoint += 1
		print(GlobalVariables.at_checkpoint)
		GlobalVariables.spawn_pos = respawn_point.global_position
		queue_free()
