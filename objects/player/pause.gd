extends Control

var paused = false
var mouse_mode

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.pressed:
			if !paused:
				paused = true
				mouse_mode = Input.mouse_mode
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				visible = true
			else:
				paused = false
				Input.mouse_mode = mouse_mode
				visible = false



func _on_continue_button_pressed() -> void:
	paused = false
	Input.mouse_mode = mouse_mode
	visible = false


func _on_back_2_main_menu_button_pressed() -> void:
	Transition.set_scene_to_main()
