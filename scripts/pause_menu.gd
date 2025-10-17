extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pause_menu: Control = $"."
var MAIN_MENU = ("res://ui/main_menu.tscn")

var paused: bool = false

func resume():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	animation_player.play_backwards("blur")
	pause_menu.visible = false
	get_tree().paused = false

func pause():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$VBoxContainer/Resume.grab_focus()
	animation_player.play("blur")
	pause_menu.visible = true
	get_tree().paused = true

func _ready() -> void:
	animation_player.play("RESET")
	pause_menu.visible = false

func _process(_delta):
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

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU)

func _on_resume_focus_exited() -> void:
	$Select.play()

func _on_restart_focus_entered() -> void:
	$Select.play()

func _on_save_focus_entered() -> void:
	$Select.play()

func _on_load_focus_entered() -> void:
	$Select.play()

func _on_options_focus_entered() -> void:
	$Select.play()

func _on_main_menu_focus_entered() -> void:
	$Select.play()

func _on_quit_focus_entered() -> void:
	$Select.play()
