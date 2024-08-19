extends Camera3D
class_name Camera

signal transform_changed

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		emit_signal("transform_changed")