extends TextureProgressBar

@onready var health_bar: TextureProgressBar = $"."

func _ready():
	value = 100

func change_health(currenthealth):
	value = currenthealth
