extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _on_body_entered(body):
	if GlobalVariables.health_bottles < 9:
		GlobalVariables.health_bottles += 1
		queue_free()
