class_name thief
extends CharacterBody2D

@export var CHASESPEED = 5750
@export var SPEED = 40
@onready var animate: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var area_2d: Area2D = $Area2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2
var player: CharacterBody2D

var on_right = 0
var chasing = false

func _ready() -> void:
	pass

func _physics_process(delta):
	handle_gravity(delta)
	change_direction()
	if chasing:
		velocity.x = CHASESPEED * delta * on_right
	elif !chasing:
		velocity.x = 0
	move_and_slide()

func handle_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func change_direction():
	if on_right < 0:
		animate.flip_h = true
		collision_shape_2d.position.x += 31
	elif on_right > 0:
		animate.flip_h = false
		collision_shape_2d.position.x -= 31

func entered(body: Node2D) -> void:
	if body is Player:
		chasing = true
		player = body
		if player.position.x < global_position.x:
			on_right = -1
		elif player.position.x > global_position.x:
			on_right = 1

func exited(body: Node2D) -> void:
	if body is Player:
		chasing = false
		player = null
