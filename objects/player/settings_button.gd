extends Button

@onready var settings_menu = $"Node/Settings"



func _on_timer_toggle_toggled(toggled_on:bool) -> void:
	Settings.set_setting("show_timer",toggled_on)


func _on_fps_toggle_toggled(toggled_on:bool) -> void:
	Settings.set_setting("show_fps",toggled_on)


func _on_h_slider_drag_ended(value_changed:bool) -> void:
	Settings.set_setting("sensitivity",value_changed)

func _on_check_button_toggled(toggled_on:bool) -> void:
	Settings.set_setting("half_portal_resolution",toggled_on)


func _on_close_button_pressed() -> void:
	settings_menu.visible = false


func _on_pressed() -> void:
	settings_menu.visible = true
	$Node/Settings/PanelContainer/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/CheckButton.button_pressed = Settings.settings.half_portal_resolution
	$Node/Settings/PanelContainer/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/HSlider.value = Settings.settings.sensitivity
	$Node/Settings/PanelContainer/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/FPSToggle.button_pressed = Settings.settings.show_fps
	$Node/Settings/PanelContainer/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/TimerToggle.button_pressed = Settings.settings.show_timer
