@tool
extends Node

var settings = {
	"shadows" : true,
	"half_portal_resolution" : false,
	"sensitivity" : 50.0,
	"show_fps": false,
	"show_timer": false,
	"levels_unlocked" : 1,
}

@onready var saveTimer = Timer.new()

signal settings_changed(key : String,value)

func _ready() -> void:
	add_child(saveTimer)
	saveTimer.one_shot = true
	saveTimer.wait_time = 2
	saveTimer.timeout.connect(_save_settings)

func _enter_tree() -> void:
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err != OK:
		return
	for key in settings.keys():
		settings[key] = config.get_value("settings",key,settings[key])


func set_setting(key,value) -> void:
	saveTimer.start()
	if settings[key] != value:
		settings[key] = value
		emit_signal("settings_changed",key,value)


func _save_settings() -> void:
	print("Saved Settings")
	var config = ConfigFile.new()
	for key in settings.keys():
		config.set_value("settings",key,settings[key])
	config.save("user://settings.cfg")
