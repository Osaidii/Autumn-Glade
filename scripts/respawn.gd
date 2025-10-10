extends Area2D

@onready var checkpoint_manager: Node = $".."
@onready var respawn_point: Marker2D = $"Respawn Point"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var green: CPUParticles2D = $green
@onready var yellow: CPUParticles2D = $yellow
@onready var red: CPUParticles2D = $red
@onready var cutscene: AnimationPlayer = $cutscene

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		GlobalVariables.at_checkpoint += 1
		cutscene.play("reached")
		GlobalVariables.spawn_pos = respawn_point.global_position
		collision_shape_2d.disabled = true
