extends Node

func _process(delta: float) -> void:
	if GlobalVariables.at_checkpoint == 0:
		$"Checkpoint Manager/Respawn/CollisionShape2D".disabled = true
	if GlobalVariables.at_checkpoint == 1:
		$"Checkpoint Manager/Respawn2/CollisionShape2D".disabled = true
	if GlobalVariables.at_checkpoint == 2:
		$"Checkpoint Manager/Respawn3/CollisionShape2D".disabled = true
	if GlobalVariables.at_checkpoint == 3:
		$"Checkpoint Manager/Respawn4/CollisionShape2D".disabled = true
	if GlobalVariables.at_checkpoint == 4:
		$"Checkpoint Manager/Respawn5/CollisionShape2D".disabled = true
