extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	$detect/DETETECTOR.monitoring = true

func _on_hurt_body_entered(body: Node2D) -> void:
	if body is Player:
		GlobalVariables.spike = true
	
func _on_detetector_body_entered(body: Node2D) -> void:
	if body is Player:
		animation_player.play("reveal")
		$detect/DETETECTOR.set_deferred("monitoring", false)
