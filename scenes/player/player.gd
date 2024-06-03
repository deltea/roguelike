class_name Player extends CharacterBody2D

@export var move_speed = 100.0
@export var rotation_animation_speed = 20.0
@export var scale_animation_speed = 15.0
@export var stretch = 0.2
@export var knockback_damping = 10.0
@export var dash_force = 600.0
@export var dash_damping = 10.0
@export var dash_rate = 1.5

@onready var anchor: Node2D = $Anchor
@onready var sprite: Sprite = $Anchor/Sprite
@onready var trail: CPUParticles2D = $Trail

var target_rotation = 0.0
var target_scale = Vector2.ONE
var knockback_velocity = Vector2.ZERO
var dash_velocity = Vector2.ZERO
var next_time_to_dash = 0.0

func _enter_tree() -> void:
	RoomManager.current_room.set_deferred("player", self)

func _physics_process(delta):
	anchor.rotation = lerp_angle(anchor.rotation, target_rotation, rotation_animation_speed * delta)
	anchor.scale = anchor.scale.lerp(target_scale, scale_animation_speed * delta)

	knockback_velocity = knockback_velocity.lerp(Vector2.ZERO, knockback_damping * delta)
	dash_velocity = dash_velocity.lerp(Vector2.ZERO, dash_damping * delta)

	var input = Input.get_vector("left", "right", "up", "down")
	velocity = input * move_speed + dash_velocity

	if input:
		target_rotation = input.angle()
		target_scale = Vector2(1 + stretch, 1 - stretch)
	else:
		target_scale = Vector2.ONE
		velocity += knockback_velocity

	if Input.is_action_just_pressed("space") and input and Clock.time >= next_time_to_dash:
		dash_velocity = input * dash_force
		next_time_to_dash = Clock.time + 1.0 / dash_rate

		RoomManager.current_room.camera.shake(0.1, 1.0)

	trail.emitting = not input == Vector2.ZERO

	move_and_slide()

func knockback(direction: Vector2, force: float):
	knockback_velocity = direction * force
