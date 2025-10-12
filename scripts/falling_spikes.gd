extends Node2D

@export var speed = 160
var current_speed = 0
var is_falling: bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	position.y += current_speed * delta

func _on_playerdetect_body_entered(body: Node2D) -> void:
	if body is Player:
		fall()

func _on_damagezone_body_entered(body: Node2D) -> void:
	if body is Player:
		GlobalVariables.is_dead = true
		animation_player.play("used")

func fall():
	current_speed = speed
