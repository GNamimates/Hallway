extends ColorRect

var force_to_level_selection = false
var current_package
var player

func _ready() -> void:
   mouse_filter = Control.MOUSE_FILTER_IGNORE
   anchor_left = 0
   anchor_top = 0
   anchor_right = 1
   anchor_bottom = 1
   color = Color(0,0,0,0)
   z_index = RenderingServer.CANVAS_ITEM_Z_MAX

var is_transitioning : bool = false
var target_scene : PackedScene

func set_scene(new_scene : PackedScene) -> void:
   if !is_transitioning:
      player = null
      target_scene = new_scene
      is_transitioning = true
      get_tree().create_tween().tween_method(_tween,0.0,1.0,0.5)

func set_scene_to_main() -> void:
   set_scene(load("res://main.tscn"))

func restart():
   if target_scene is PackedScene:
      set_scene(target_scene)

func _tween(x) -> void:
   color = Color(0,0,0,x)
   if x == 1:
      get_tree().change_scene_to_packed(target_scene)
      Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
      get_tree().create_tween().tween_method(_tween,1.0,0.0,0.5)
      is_transitioning = false 