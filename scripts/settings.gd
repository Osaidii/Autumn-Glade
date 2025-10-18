extends Control

var bg_volume
var master_volume

var master_bus = AudioServer.get_bus_index("Master")
var bg_music_bus = AudioServer.get_bus_index("Bg Music")

@onready var master_volume_slider: HSlider = $"MarginContainer/VBoxContainer/Master Volume"
@onready var volume_slider: HSlider = $MarginContainer/VBoxContainer/BgMusicSlider

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func _on_volume_value_changed(value: float) -> void:
	bg_volume = volume_slider.value
	bg_music_bus.set_bus_effect_volume_db(bg_volume)

func _on_master_volume_value_changed(value: float) -> void:
	master_bus = master_volume_slider.value
	master_bus.set_bus_effect_volume_db(master_bus)
