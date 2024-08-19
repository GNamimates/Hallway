@tool
extends Node3D
class_name Portal

@export var pair : Portal : set = set_pair
@export var dimensions : Vector2 = Vector2(2.0, 3.0) : set = set_dimensions
@export var can_teleport : bool
@onready var portal_camera : Camera3D = $SubViewport/Camera3D
@onready var player : Player 

var cooldown = false

func _setting_changed(key : String,value) -> void:
	if key == "half_portal_resolution":
		_resized()

func set_pair(new):
	pair = new
	if new is Portal:
		if new.pair != self:
			new.pair = self

func _ready() -> void:
	Settings.settings_changed.connect(_setting_changed)
	if %Player is Player:
		player = %Player
	$Mesh.material_override = $Mesh.material_override.duplicate()
	$Mesh.material_override.set_shader_parameter("portal",$SubViewport.get_texture())
	
	# Resizing subviewports
	if Engine.is_editor_hint(): EditorInterface.get_editor_viewport_3d(0).size_changed.connect(_resized)
	else: get_tree().root.size_changed.connect(_resized)
	_resized()
	if !Engine.is_editor_hint():
		get_viewport().get_camera_3d().transform_changed.connect(_transform_changed)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_transform_changed()

var last_camera_sign = 1
var player_inside = false
var travel = false
func _transform_changed() -> void:
	
	if pair is Portal:
		# Get camera
		var cam : Camera3D
		if Engine.is_editor_hint(): cam = EditorInterface.get_editor_viewport_3d(0).get_camera_3d()
		else: cam = get_viewport().get_camera_3d()
		
		if cam.global_position.distance_to(global_position) < 20:
			$SubViewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		else:
			$SubViewport.render_target_update_mode = SubViewport.UPDATE_DISABLED
		
		# Camera
		var self_global_transform = global_transform
		self_global_transform.basis = self_global_transform.basis.rotated(self_global_transform.basis.y.normalized(),PI)
		var local2portal = self_global_transform.affine_inverse() * cam.global_transform
		
		portal_camera.global_transform = pair.global_transform * local2portal
		portal_camera.fov = cam.fov
		var d = dimensions * 0.5
		
		# Box SDF for the clipping plane
		var box = Vector3(d.x,d.y,0)
		var q = abs((portal_camera.global_position - pair.to_global(Vector3.ZERO))) - box
		var e = min(max(q.x,max(q.y,q.z)),0)
		portal_camera.near = max((Vector3(max(q.x,0),max(q.y,0),max(q.z,0)) + Vector3(e,e,e)).length()-0.5,0.01)
		
		# Teleportation
		var camera_sign = sign(local2portal.origin.z)
		if player and camera_sign != last_camera_sign:
			last_camera_sign = camera_sign
			if can_teleport and (not cooldown) and player_inside:
				cooldown = true
				
				player.velocity = pair.global_basis * self_global_transform.basis.inverse() * player.velocity
				player.global_transform = pair.global_transform * self_global_transform.affine_inverse() * player.global_transform
				
				return
		cooldown = false
		

func _resized() -> void:
	if !is_node_ready(): await ready
	var multiplier = 1
	if Settings.settings.half_portal_resolution:
		multiplier = 0.5
	if Engine.is_editor_hint():
		$SubViewport.size = EditorInterface.get_editor_viewport_3d(0).size * multiplier
	else:
		$SubViewport.size = get_tree().root.size * multiplier


func set_dimensions(new_dimensions : Vector2) -> void:
	dimensions = new_dimensions
	if !is_node_ready(): await ready
	$Mesh.scale = Vector3(dimensions.x*0.5-0.01,dimensions.y*0.5-0.01,0.45)
	$Area/CollisionShape3D.shape.size = Vector3(dimensions.x,dimensions.y,1)
	if pair and pair.dimensions != dimensions:
		pair.set_dimensions(dimensions)



func _on_area_body_entered(body: Node3D) -> void:
	if body == player:
		player_inside = true



func _on_area_body_exited(body: Node3D) -> void:
	if body == player:
		player_inside = false
