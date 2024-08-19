@tool
extends Button
class_name LevelButton

@export var level : PackedScene

func _ready() -> void:
	text = str(self.get_index()+1)