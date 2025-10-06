class_name player
extends CharacterBody2D

@export var player: CharacterBody2D
@export var CHASESPEED = 100
@export var SPEED = 50
@export var ACCELERATION = 150

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2
var right_bounds: Vector2
var left_bounds: Vector2

enum States {
	WANDER,
	CHASE,
	HIT,
	DIE
}

var current_state = States.WANDER

func _ready() -> void:
	left_bounds = self.position + Vector2(-200, 0)
	right_bounds = self.position + Vector2(200, 0)

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_movement(delta)
	change_direction()
	move_and_slide()

func chase_player():
	timer.stop()
	current_state = States.CHASE

func stop_chase():
	if timer.time_left <= 0:
		timer.start()
	
func handle_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func change_direction():
	pass

func handle_movement(delta):
	if current_state == States.WANDER:
		velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(direction * CHASESPEED, ACCELERATION * delta)


func _on_timer_timeout() -> void:
	current_state = States.WANDER
