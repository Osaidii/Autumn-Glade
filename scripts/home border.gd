extends Area2D

@onready var collision: CollisionShape2D = $CollisionShape2D
@export var player: CharacterBody2D

func _ready() -> void:
	collision.disabled = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		print("here")
