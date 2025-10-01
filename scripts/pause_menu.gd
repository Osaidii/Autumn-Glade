extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pause_menu: Control = $"."


var paused: bool = false

func resume():
	animation_player.play_backwards("blur")
	pause_menu.visible = false
	get_tree().paused = false
	

func pause():
	animation_player.play("blur")
	pause_menu.visible = true
	get_tree().paused = true
	

func _ready() -> void:
	animation_player.play("RESET")
	pause_menu.visible = false

func _process(delta):
	logic()

func logic():
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused == true:
			resume()
		elif get_tree().paused == false:
			pause()

func _on_resume_pressed() -> void:
	resume()

func _on_quit_pressed() -> void:
	Scenetransition.change_scene()
	await get_tree().create_timer(1.5).timeout
	get_tree().quit()
