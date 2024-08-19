@tool
extends Node3D
class_name BigRedButton

var is_pressed = false
@export var power = false
signal power_changed


func _update_button():
	if !is_pressed and $Area3D.get_overlapping_bodies().size() > 0 or $PlayerDetector.get_overlapping_areas().size() > 0:
		is_pressed = true
		power = !power
		power_changed.emit()
		$Wall2.position.y = 0.05
	else:
		$Wall2.position.y = 0.2
		power_changed.emit()


func _on_area_3d_body_exited(body:Node3D) -> void:
	_update_button()


func _on_area_3d_body_entered(body:Node3D) -> void:
	_update_button()


func _on_player_detector_area_exited(area:Area3D) -> void:
	_update_button()


func _on_player_detector_area_entered(area:Area3D) -> void:
	_update_button()