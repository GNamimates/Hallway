@tool
extends StaticBody3D

@export var dimensions : Vector3 = Vector3(1.0, 1.0, 1.0) : set = set_dimensions
@export var material : Material : set = set_material
@export var can_collide : bool = true

func _ready():
	$MeshInstance3D.mesh = BoxMesh.new()
	$CollisionShape3D.shape = BoxShape3D.new()
	if !can_collide:
		$CollisionShape3D.disabled = true


func _snap(value):
	return floor(max(float(value) * 16,1) + 0.5) / 16


func set_dimensions(new_dimensions : Vector3) -> void:
	dimensions = new_dimensions
	dimensions.x = _snap(dimensions.x)
	dimensions.y = _snap(dimensions.y)
	dimensions.z = _snap(dimensions.z)
	if !is_node_ready(): await ready
	$MeshInstance3D.mesh.size = dimensions
	$CollisionShape3D.shape.size = dimensions
	if material is StandardMaterial3D:
		$MeshInstance3D.material_override.uv1_offset = dimensions * -0.5


func set_material(new_material : Material) -> void:
	material = new_material
	if !is_node_ready(): await ready
	$MeshInstance3D.material_override = material.duplicate()
	set_dimensions(dimensions)

