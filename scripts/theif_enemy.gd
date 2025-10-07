class_name thief
extends CharacterBody2D

@export var CHASESPEED = 75
@export var SPEED = 40
@export var ACCELERATION = 150
@onready var animate: AnimatedSprite2D = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2

var chasing = false
var player: CharacterBody2D

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if chasing:
		position += (player.position - position) / CHASESPEED
	move_and_slide()

func handle_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func change_direction():
	pass

func _on_detection_body_entered(body: Node2D) -> void:
	player = body
	chasing = true
	
func _on_detection_body_exited(body: Node2D) -> void:
	player = null
	chasing = false
