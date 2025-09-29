extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func change_scene():
	animation_player.play("dissolve")

func end_transition():
	animation_player.play_backwards("dissolve")
