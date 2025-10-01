class_name Player
extends CharacterBody2D

var SPEED = 4000
@export var gravity = 800
@export var walkspeed = 4000
@export var runspeed = 8000
@export var JUMP_VELOCITY = -270.0
@export var health = 100

var direction: int

@onready var animations: AnimatedSprite2D = $Animations
@onready var collision: CollisionShape2D = $Collision
@onready var health_bar: TextureProgressBar = $"Game Screen/HealthBar"
@onready var num_of_bottles: Label = $"Game Screen/Label"
@onready var attack_cooldown: Timer = $attack_cooldown
@onready var combo_reset: Timer = $combo_reset

const IDLE = preload("res://collisions/idle.tres")
const CROUTCH = preload("res://collisions/croutch.tres")

var is_walking = false
var is_running = false
var is_jumping = false
var is_falling = false
var is_crouching = false
var is_dead = false
var is_healing = false
var is_attacking = false
var can_attack = true

enum AttackStates {ATT1, ATT2, ATT3, CROUCH}
var which_att_state = AttackStates.ATT1

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("damage_temp"):
		health -= 30
	if event.is_action_pressed("heal") and !is_crouching and !is_falling and !is_jumping and HealthBottles.health_bottles > 0 and health < 100:
		is_healing = true
		health += 30
		HealthBottles.health_bottles -= 1
	if event.is_action_pressed("attack") and !is_jumping and !is_falling and !is_healing and can_attack:
		if is_attacking:
			pass
		else:
			is_attacking = true
			if is_crouching:
				which_att_state = AttackStates.CROUCH
			attack_anims()

func _ready():
	collision.disabled = false
	collision.shape = IDLE
	collision.position.x = 0
	collision.position.y = 0
	is_dead = false
	HealthBottles.health_bottles = 0

func _physics_process(delta: float) -> void:
	#No Control if Dead
	if is_dead: return
	if is_attacking: return
	
	#Handle Health Bar
	health_bar.change_health(health)
	
	#Handle Health Bottles
	num_of_bottles.text = str(HealthBottles.health_bottles)
	
	#Direction Set
	direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	#Health Set
	healthset()
	
	#Play Anims
	anims()
	
	#Change Direction
	facing_dir()
	
	#Change Speed
	if Input.is_action_pressed("run") and direction != 0 and !is_crouching and !is_healing:
		SPEED = runspeed
		is_running = true
	elif !Input.is_action_pressed("run") and direction != 0 and !is_crouching and !is_healing:
		is_running = false
		is_walking = true
		SPEED = walkspeed
	elif direction == 0:
		is_running = false
		is_walking = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	#Variables Changing
	if is_on_floor():
		is_falling = false
	
	if health <= 0:
		is_dead = true
	
	if Input.is_action_pressed("crouch") and !is_falling and !is_jumping and is_on_floor()  and !is_healing:
		is_crouching = true
		collision.shape = CROUTCH
		collision.position.y = 4
	else:
		is_crouching = false
		collision.shape = IDLE
		collision.position.y = 0
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and !is_crouching and !is_healing:
		velocity.y = JUMP_VELOCITY
		is_jumping = true
	elif velocity.y > 0:
		is_jumping = false
	
	if velocity.y > 0 and !is_on_floor():
		is_falling = true
	
	#Move Logic
	if direction:
		velocity.x = direction * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta * 0.08)
		
	#If Died
	if is_dead:
		dead()
		
	if !is_crouching and !is_healing and !is_attacking:
		move_and_slide()

func anims():
	if !is_dead:
		if is_healing:
			animations.play("heal")
			await get_tree().create_timer(1.1).timeout
			is_healing = false
		elif is_crouching:
			animations.play("crouch")
		elif is_jumping:
			animations.play("jump")
		elif is_falling:
			animations.play("fall")
		elif is_running:
			animations.play("run")
		elif is_walking:
			animations.play("walk")
		else:
			if health < 40:
				animations.play("damaged_idle")
			else:
				animations.play("idle")

func attack_anims():
	if is_attacking:
		if which_att_state == AttackStates.ATT1:
			animations.play("attack 1")
			await get_tree().create_timer(0.4).timeout
			which_att_state = AttackStates.ATT2
		elif which_att_state == AttackStates.ATT2:
			animations.play("attack 2")
			await get_tree().create_timer(0.44).timeout
			which_att_state = AttackStates.ATT3
		elif which_att_state == AttackStates.ATT3:
			animations.play("attack 3")
			await get_tree().create_timer(0.7).timeout
			which_att_state = AttackStates.ATT1
		elif which_att_state == AttackStates.CROUCH:
			animations.play("crouch attack")
			await get_tree().create_timer(0.7).timeout
			which_att_state == AttackStates.ATT1
		attack_cooldown.start()
		combo_reset.start()
		is_attacking = false

func facing_dir():
	if !is_healing and !is_attacking and !is_dead:
		if direction < 0:
			animations.flip_h = true
			collision.position.x = -5
		if direction > 0:
			animations.flip_h = false
			collision.position.x = 0

func healthset():
	if health > 100:
		health = 100
	if health < 0:
		health = 0

func dead():
	collision.disabled = true
	animations.play("die")
	Scenetransition.change_scene()
	await get_tree().create_timer(1.5).timeout
	get_tree().reload_current_scene()
	Scenetransition.end_transition()

func _on_attack_cooldown_timeout() -> void:
	can_attack = true

func _on_combo_reset_timeout() -> void:
	which_att_state = AttackStates.ATT1
