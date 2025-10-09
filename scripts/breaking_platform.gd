extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D
@export var time: float = 1.5
var has_player

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		has_player = true
		$Timer.start(time)

func _on_timer_timeout() -> void:
	has_player = false
	queue_free()
