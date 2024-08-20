extends Button

@onready var settings_menu = $"Node/Settings"



func _on_timer_toggle_toggled(toggled_on:bool) -> void:
	Settings.set_setting("show_timer",toggled_on)


func _on_fps_toggle_toggled(toggled_on:bool) -> void:
	Settings.set_setting("show_fps",toggled_on)


func _on_h_slider_value_changed(value:float) -> void:
	Settings.set_setting("sensitivity",value)

func _on_close_button_pressed() -> void:
	settings_menu.visible = false


func _on_pressed() -> void:
	settings_menu.visible = true
	$Node/Settings/PanelContainer/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/ShadowButton.button_pressed = Settings.settings.shadows
	$Node/Settings/PanelContainer/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/HSlider.set_value_no_signal(Settings.settings.sensitivity)
	$Node/Settings/PanelContainer/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer2/ResolutionHSlider.set_value_no_signal(Settings.settings.portal_resolution)
	$Node/Settings/PanelContainer/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/FPSToggle.button_pressed = Settings.settings.show_fps
	$Node/Settings/PanelContainer/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/TimerToggle.button_pressed = Settings.settings.show_timer





func _on_shadow_button_toggled(toggled_on:bool) -> void:
	Settings.set_setting("shadows",toggled_on)


func _on_resolution_h_slider_value_changed(value:float) -> void:
	Settings.set_setting("portal_resolution",value)
