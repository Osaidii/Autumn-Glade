extends Control

var bg_volume
var bus_index = AudioServer.get_bus_index("Bg Music")
@onready var volume_slider: HSlider = $MarginContainer/VBoxContainer/BgMusicSlider

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func _on_volume_value_changed(value: float) -> void:
	bg_volume = volume_slider.value
	bus_index.set_bus_effect_volume_db(bg_volume)


func _on_master_volume_value_changed(value: float) -> void:
	pass # Replace with function body.
