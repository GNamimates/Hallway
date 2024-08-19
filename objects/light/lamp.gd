extends MeshInstance3D

func _ready() -> void:
	Settings.settings_changed.connect(_on_settings_changed)
	$OmniLight3D.shadow_enabled = Settings.settings.shadows


func _on_settings_changed(key : String,value) -> void:
	if key == "shadow":
		$OmniLight3D.shadow_enabled = value