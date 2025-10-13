extends AnimatableBody2D

@export var move_speed = 0.01
var direction = 1

@onready var path_follow_2d: PathFollow2D = $".."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	path_follow_2d.progress_ratio += move_speed * direction
