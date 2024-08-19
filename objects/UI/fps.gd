extends Label


func _ready() -> void:
	Settings.settings_changed.connect(_on_settings_changed)
	z_index = RenderingServer.CANVAS_ITEM_Z_MAX
	visible = Settings.settings.show_fps

func _on_settings_changed(key : String,value) -> void:
	if key == "show_fps":
		visible = value

func _process(delta: float) -> void:
	var fps = Engine.get_frames_per_second()
	text = str("FPS:",fps)