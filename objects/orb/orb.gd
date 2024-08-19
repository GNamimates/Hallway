@tool
extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if %Player is Player:
		%Player.add_total_orb()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var t = float(Time.get_ticks_msec())/200
	$MeshOut.rotation.x = t*0.3
	$MeshOut.rotation.y = t
	
	$MeshIn.rotation.x = t*0.3
	$MeshIn.rotation.y = t

func _on_area_entered(area:Area3D) -> void:
	if area.get_parent() is Player:
		area.get_parent().add_orb()
		$CollisionShape3D.queue_free()
		get_tree().create_tween().tween_property(self,"global_position",area.get_parent().global_position,1.3)
		get_tree().create_tween().tween_property(self,"scale",Vector3.ZERO,1.3)
		get_tree().create_tween().tween_property($OmniLight3D,"light_energy",0,1.3)
		$Collect.play()
		await get_tree().create_timer(1.3).timeout
		queue_free()