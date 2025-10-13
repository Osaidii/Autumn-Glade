extends AnimatableBody2D

@export var move_speed = 0.01

@onready var path_follow_2d: PathFollow2D = $".."
@onready var animator: AnimationPlayer = $AnimationPlayer

var direction = 1
var progress_ratio

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	animator.play("notlooping")
