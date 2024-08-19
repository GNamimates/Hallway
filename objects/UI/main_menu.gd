extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Transition.force_to_level_selection:
		visible = false
		$"../LevelSelection".visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_levelsbutton_pressed() -> void:
	visible = false
	$"../LevelSelection".visible = true
