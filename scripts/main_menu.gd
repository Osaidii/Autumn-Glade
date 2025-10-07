extends Control

@onready var animations: AnimatedSprite2D = $Animations
const LEVEL_1 = preload("res://scenes/Level1.tscn") as PackedScene
@onready var timer: Timer = $Timer
@onready var select: AudioStreamPlayer = $Select

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	select.volume_db = -80
	%Play.grab_focus()
	await  get_tree().create_timer(1).timeout
	select.volume_db = 0

func play():
	$Select.play()
	Scenetransition.change_scene()
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_packed(LEVEL_1)
	Scenetransition.end_transition()

func quit():
	$Select.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

func settings():
	pass # Replace with function body.

func _on_play_focus_entered() -> void:
	$Select.play()

func _on_settings_focus_entered() -> void:
	$Select.play()

func _on_quit_focus_entered() -> void:
	$Select.play()
