extends CharacterBody3D
class_name Player

const WALK_SPEED = 1
const SPRINT_SPEED = 2.
const JUMP_VELOCITY = 10

var orbs : int = 0
var total_orbs : int = 0
var can_win : bool = false

@onready var feet : RayCast3D = $Feet
@onready var feet1 : RayCast3D = $Feet1
@onready var feet2 : RayCast3D = $Feet2
@onready var feet3 : RayCast3D = $Feet3
@onready var arm = $Arm
@onready var camera : Camera3D = $Neck/Camera3D
@onready var neck = $Neck
@onready var sound_left := $LeftStepAudioStreamPlayer
@onready var sound_right := $RightStepAudioStreamPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var eye_rotation := Vector2.ZERO

# Analytics
var distance_traveled = 0
var travel_speed = 0
var is_grounded = false

var _last_step_distance = 0
var foot_order = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	
	var leg_height : float
	var plane : Plane
	if feet.is_colliding():
		leg_height += (to_local(feet.global_position).y - to_local(feet.get_collision_point()).y - .5)
	else:
		leg_height = 2
	var walk_speed: float
	if Input.is_action_pressed("sprint"):
		walk_speed = SPRINT_SPEED
	else:
		walk_speed = WALK_SPEED
	
	travel_speed = velocity.length()
	if leg_height < 1.2:
		plane = Plane(
			Vector3(global_position.x,feet1.global_position.y,global_position.z) - feet1.get_collision_point(),
			Vector3(global_position.x,feet2.global_position.y,global_position.z) - feet2.get_collision_point(),
			Vector3(global_position.x,feet3.global_position.y,global_position.z) - feet3.get_collision_point(),
			)
		plane.d = 0
		var input_dir = Input.get_vector("strafe_left", "strafe_right", "walk_forward", "walk_backward")
		if input_dir.length_squared() > 0.1:
			input_dir = input_dir.normalized()
		velocity *= 0.8
		velocity += $Neck.global_basis * Vector3(input_dir.x,0,input_dir.y) * walk_speed
		distance_traveled += travel_speed
		
		if !is_grounded:
			is_grounded = true
			if velocity.y < -4:
				sound_left.volume_db = 10 # Left Foot
				sound_right.volume_db = 10 # Left Foot
				sound_left.play() # Left Foot
				sound_right.play() # Right Foot
		if Input.is_action_just_pressed("jump"):
			velocity += global_basis.y * JUMP_VELOCITY
			sound_left.volume_db = 10 # Left Foot
			sound_right.volume_db = 10 # Left Foot
			sound_left.play() # Left Foot
			sound_right.play() # Right Foot
	else:
		plane = Plane(Vector3.UP)
		if is_grounded:
			is_grounded = false
	velocity -= global_basis.y * (clampf((((leg_height) - 1) * 3),-99,1)) * delta * gravity
	move_and_slide()
	if distance_traveled-_last_step_distance > 100:
		_last_step_distance = distance_traveled
		sound_left.volume_db = -19 # Left Foot
		sound_right.volume_db = -19 # Left Foot
		if foot_order: sound_left.play()
		else: sound_right.play()
		foot_order = !foot_order
	
	var walk_effect_strength = min(1,travel_speed * 0.5)
	$Neck/Camera3D.rotation_degrees.z = cos(distance_traveled / 100 * PI) * 0.2 * walk_effect_strength
	
	arm.rotation_degrees.y = lerp(arm.rotation_degrees.y,eye_rotation.y,min(delta * 30,1))
	arm.rotation_degrees.x = lerp(arm.rotation_degrees.x,eye_rotation.x,min(delta * 20,1)) - clampf(velocity.y*0.1,-1,1) * 2 + (abs(sin(distance_traveled / 100 * PI) * 0.1) * 5 * walk_effect_strength)


func add_total_orb():
	total_orbs += 1
	can_win = true
	$CanvasLayer/LabelTotal.text = str(total_orbs)

func add_orb():
	orbs += 1
	$CanvasLayer/LabelFound.text = str(orbs)
	if can_win:
		if orbs == total_orbs:
			$CanvasLayer/LabelWin.visible = true
			$Complete.play()
			await get_tree().create_timer(1).timeout
			Transition.force_to_level_selection = true
			Transition.set_scene_to_main()


func _input(event):
	if event is InputEventMouseMotion:
		var sensitivity = lerp(0.0,0.2,float(Settings.settings.sensitivity) / 100.0)
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			eye_rotation.y -= event.relative.x * sensitivity
			eye_rotation.x = clampf(eye_rotation.x - event.relative.y * sensitivity,-89.9,89.9)
			neck.rotation_degrees.y = eye_rotation.y
			camera.rotation_degrees.x = eye_rotation.x