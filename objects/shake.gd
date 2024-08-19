extends Node3D

@onready var noise = FastNoiseLite.new()

func _ready() -> void:
	noise.fractal_octaves = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var t = float(Time.get_ticks_msec())/300
	rotation_degrees.x = noise.get_noise_1d(t) * 2
	rotation_degrees.y = noise.get_noise_1d(t+89) * 5
	rotation_degrees.z = noise.get_noise_1d(t+129) * 5
