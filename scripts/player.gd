class_name Player
extends CharacterBody2D

@export var SPEED = 4000
@export var gravity = 800
@export var walkspeed = 4000
@export var runspeed = 8000
@export var JUMP_VELOCITY = -270.0
@export var health = 100
@export var can_control: bool = false

var direction: int
var anim = ""

@onready var animations: AnimatedSprite2D = $Animations
@onready var collision: CollisionShape2D = $Collision
@onready var health_bar: TextureProgressBar = $"Game Screen/HealthBar"
@onready var num_of_bottles: Label = $"Game Screen/Label"
@onready var attack_cooldown: Timer = $attack_cooldown
@onready var combo_reset: Timer = $combo_reset
@onready var coyote_time: Timer = $coyote_time
@onready var cutscenes: AnimationPlayer = $"../cutscenes"

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
var was_on_floor = true

enum AttackStates {ATT1, ATT2, ATT3, CROUCH}
var which_att_state = AttackStates.ATT1

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("damage_temp"):
		health -= 30
	if event.is_action_pressed("heal") and !is_crouching and !is_falling and !is_jumping and GlobalVariables.health_bottles > 0 and health < 100:
		is_healing = true
		health += 30
		GlobalVariables.health_bottles -= 1
	if event.is_action_pressed("attack") and !is_jumping and !is_falling and !is_healing and can_attack:
		if is_attacking:
			pass
		else:
			is_attacking = true
			if is_crouching:
				which_att_state = AttackStates.CROUCH
			attack_anims()

func _ready():
	if GlobalVariables.at_checkpoint < 1:
		cutscenes.play("intro")
	else:
		cutscenes.play("move_out_of_way")
	self.global_position = GlobalVariables.spawn_pos
	collision.disabled = false
	collision.shape = IDLE
	collision.position.x = 2
	collision.position.y = 0
	is_dead = false
	GlobalVariables.health_bottles = 0

func _physics_process(delta: float) -> void:
	if !can_control: return
	#No Control if Dead
	if is_dead: return
	if is_attacking: return
	if GlobalVariables.spawn_pos.x == 2841:
		cutscenes.play("enemy_attack")
	
	if GlobalVariables.move_tut == true:
		$"../cutscenes".play("move_tut")
		GlobalVariables.move_tut = false
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		GlobalVariables.moved = true
	if GlobalVariables.moved == true:
		$"../cutscenes".play("move_out")
	
	set_mouse()
	
	#Handle Health Bar
	health_bar.change_health(health)
	
	#Handle Health Bottles
	num_of_bottles.text = str(GlobalVariables.health_bottles)
	
	#Direction Set
	direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	#Health Set
	healthset()
	
	#Play Anims
	anims(anim)
	
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
	was_on_floor = is_on_floor()
	
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
	if Input.is_action_just_pressed("jump") and !is_crouching and !is_healing and !is_jumping:
		if is_on_floor() or !coyote_time.is_stopped():
			velocity.y = JUMP_VELOCITY
			is_jumping = true
	elif is_on_floor():
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
		
		if was_on_floor and !is_on_floor():
			coyote_time.start()

func anims(animation):
	if animation == "lying down":
		animations.play("lying down")
	if anim == "get up":
		animations.play("get_up")
	elif !is_dead:
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
	if !can_control: return
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

func set_mouse():
	if scene_file_path == "res://scenes/Level1.tscn":
		Input.MOUSE_MODE_CAPTURED
	else:
		Input.MOUSE_MODE_VISIBLE

func facing_dir():
	if !is_healing and !is_attacking and !is_dead:
		if direction < 0:
			animations.flip_h = true
			collision.position.x = -3
		if direction > 0:
			animations.flip_h = false
			collision.position.x = 2

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

func cutscene_alr_played():
	GlobalVariables.cutscene_played = true
	animations.global_position.y += -2
	GlobalVariables.move_tut = true

func _on_attack_cooldown_timeout() -> void:
	can_attack = true

func _on_combo_reset_timeout() -> void:
	which_att_state = AttackStates.ATT1
