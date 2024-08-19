extends AudioStreamPlayer


func _ready() -> void:
	stream = preload("res://audio/hallway_radio.ogg")
	play()