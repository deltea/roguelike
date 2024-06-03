class_name Sprite extends Sprite2D

const shadow_offset_direction = Vector2(0, 1)

@export_group("Dynamics")
@export var scale_dynamics_enabled = true
@export var scale_dynamics: DynamicsResource
@export var rotation_dynamics_enabled = true
@export var rotation_dynamics: DynamicsResource

@export_group("Drop Shadow")
@export var shadow_enabled = false
@export var shadow_color = Color.BLACK
@export var shadow_offset = 6.0
@export var shadow_z = -2

@onready var scale_dynamics_solver := Dynamics.create_dynamics_vector(scale_dynamics)
@onready var rotation_dynamics_solver := Dynamics.create_dynamics(rotation_dynamics)

var target_scale = Vector2.ONE
var target_rotation_degrees = 0.0
var shadow: Sprite2D

func _ready() -> void:
	target_scale = scale
	target_rotation_degrees = rotation_degrees

	if shadow_enabled:
		shadow = Sprite2D.new()
		shadow.texture = texture
		shadow.z_index = shadow_z
		shadow.region_enabled = region_enabled
		shadow.region_rect = region_rect
		shadow.self_modulate = shadow_color
		add_child(shadow)

func _process(_delta: float) -> void:
	if scale_dynamics and scale_dynamics_enabled:
		scale = scale_dynamics_solver.update(target_scale)
	else:
		scale = target_scale

	if rotation_dynamics and rotation_dynamics_enabled:
		rotation_degrees = rotation_dynamics_solver.update(target_rotation_degrees)
	else:
		rotation_degrees = target_rotation_degrees

	if shadow:
		shadow.global_position = global_position + shadow_offset_direction * shadow_offset
		shadow.global_rotation = global_rotation
		shadow.global_scale = global_scale

func impact_scale(value: Vector2):
	scale_dynamics_solver.set_value(value)

func impact_rotation(value: float):
	rotation_dynamics_solver.set_value(value)

func blink(duration: float, iterations: int, direction: String):
	var step_duration = duration / iterations
	for i in range(iterations):
		visible = true if direction == "out" else false
		await Clock.wait(step_duration - (i / float(iterations) * step_duration))
		visible = false if direction == "out" else true
		await Clock.wait(i / float(iterations) * step_duration)

func blink_out(duration: float = 1.0, iterations: int = 10):
	blink(duration, iterations, "out")

func blink_in(duration: float = 1.0, iterations: int = 10):
	blink(duration, iterations, "in")

func flash(color: Color, duration: float = 0.1):
	var prev_color = self_modulate

	self_modulate = color
	await Clock.wait(duration)
	self_modulate = prev_color

func _on_blink_timer_timeout() -> void:
	visible = not visible
