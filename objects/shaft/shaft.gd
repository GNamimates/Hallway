@tool
extends Node3D
class_name Shaft

@export var enabled : bool
@export_range(0.1, 10.0) var duration : float
@export var time = 0.0

@export var source : BigRedButton : set = set_source
@export var from : Node3D
@export var to : Node3D

@export var active = false
var was_active = false
func _physics_process(delta: float) -> void:
	if from is Node3D and to is Node3D:
		if (enabled and duration != time) or (!enabled and time != 0.0):
			active = true
		else:
			active = false
		if was_active != active:
			was_active = active
			if active:
				$Start.stop()
				$Start.play()
				if enabled:
					$Mid.pitch_scale = 0.890899 
				else:
					$Mid.pitch_scale = 0.793701
				$Mid.play()
			else:
				$End.stop()
				$End.play()
				$Mid.stop()
		if active:
			if enabled:
				time = clampf(time + delta, 0.0, duration)
			else:
				time = clampf(time - delta, 0.0, duration)
		if active: # Display
			var t = time / duration
			global_position = lerp(from.global_position, to.global_position, t)


func set_source(new_source : BigRedButton) -> void:
	if source is BigRedButton:
		source.power_changed.disconnect(_on_power_changed)
	source = new_source
	if source is BigRedButton:
		source.power_changed.connect(_on_power_changed)

func _on_power_changed() -> void:
	enabled = source.power