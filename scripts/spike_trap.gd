extends Node2D

@export var speed = 550
var current_speed = 0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var marker_2d: Marker2D = $Marker2D
@onready var detetector: Area2D = $detect/DETETECTOR
@onready var hurtbox: CollisionPolygon2D = $hurt/hurt/CollisionShape2D
@onready var hurt: Node2D = $hurt
@onready var sprite_2d: Sprite2D = $hurt/Sprite2D

func _ready() -> void:
	detetector.monitoring = true
	$"../Node2D3/hurt/hurt/CollisionShape2D".disabled = true

func _physics_process(delta: float) -> void:
	hurt.position.y += current_speed * delta
	if hurt.position.y >= marker_2d.position.y - 6:
		current_speed = 0
		hurt.position.y = marker_2d.position.y - 6
		$"../Node2D3/hurt/hurt/CollisionShape2D".disabled = false
		

func _on_playerdetect_body_entered(body: Node2D) -> void:
	if body is Player:
		animation_player.play("shakeandfall")

func fall():
	current_speed = speed

func destroy():
	queue_free()

func _on_hurt_body_entered(body: Node2D) -> void:
	if body is Player:
		GlobalVariables.is_dead = true
