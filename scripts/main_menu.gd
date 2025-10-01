extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
const LEVEL_1 = preload("res://scenes/Level1.tscn") as PackedScene
@onready var timer: Timer = $Timer

func play():
	Scenetransition.change_scene()
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_packed(LEVEL_1)
	Scenetransition.end_transition()

func quit():
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

func settings():
	pass # Replace with function body.
