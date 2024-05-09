class_name Camera extends Camera2D

@export var mouse_strength = 0.08
@export var look_strength = 20.0
@export var impact_rotation = 5.0
@export var offset_smoothing = 10.0
@export var shake_damping_speed = 1.0
@export var follow_dynamics: DynamicsResource

@onready var follow_dynamics_solver: DynamicsSolverVector = Dynamics.create_dynamics_vector(follow_dynamics)

var shake_duration = 0.0;
var shake_magnitude = 0.0;
var shake_offset = Vector2.ZERO
var target_zoom = Vector2.ONE

func _enter_tree() -> void:
	RoomManager.current_room.set_deferred("camera", self)

func _process(delta: float) -> void:
	position = follow_dynamics_solver.update(RoomManager.current_room.player.position)

	var mouse_offset = (get_global_mouse_position() - global_position) * mouse_strength
	var look_offset = Input.get_vector("left", "right", "up", "down") * look_strength
	if shake_duration > 0:
		shake_offset = Utils.random_direction() * shake_magnitude
		shake_duration -= delta * shake_damping_speed
	else:
		shake_duration = 0
		shake_offset = Vector2.ZERO

	offset = offset.lerp(mouse_offset + look_offset, offset_smoothing * delta) + shake_offset

func shake(duration: float, magnitude: float):
	shake_duration = duration
	shake_magnitude = magnitude
