extends Path2D

@export var loop = true
@export var speed_open = 2.0 
@export var speed_closed = 1.0

@onready var path: PathFollow2D = $PathFollow2D
@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if not loop:
		animation.play("follow")
		animation.speed_scale = speed_closed
		set_process(false)

func _process(delta: float) -> void:
	path.progress += speed_open
	
