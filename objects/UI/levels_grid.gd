extends GridContainer

var selected_level : LevelButton

func _ready() -> void:
	for child in get_children():
		child.pressed.connect(_on_level_button_pressed.bind(child))


func _on_level_button_pressed(button : LevelButton) -> void:
	$"../LabelLevelTitle".text = str(button.get_index()+1," - ",button.name)
	selected_level = button
	$"../PlayButton".disabled = false

func _on_play_button_pressed() -> void:
	Transition.set_scene(selected_level.level)
