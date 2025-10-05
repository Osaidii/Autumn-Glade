extends Node

var last_location
@onready var player: Player = $"../CharacterBody2D"


func _ready():
	last_location = player.global_position
