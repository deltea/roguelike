class_name Player extends CharacterBody2D

@export var move_speed = 100.0
@export var rotation_animation_speed = 20.0
@export var scale_animation_speed = 15.0
@export var stretch = 0.2

@onready var anchor: Node2D = $Anchor
@onready var sprite: Sprite = $Anchor/Sprite
@onready var trail: GPUParticles2D = $Trail

var target_rotation = 0.0
var target_scale = Vector2.ONE

func _enter_tree() -> void:
	if RoomManager.current_room: RoomManager.current_room.set_deferred("player", self)

func _physics_process(delta):
	anchor.rotation = lerp_angle(anchor.rotation, target_rotation, rotation_animation_speed * delta)
	anchor.scale = anchor.scale.lerp(target_scale, scale_animation_speed * delta)

	var input = Input.get_vector("left", "right", "up", "down")
	velocity = input * move_speed
	if input:
		target_rotation = input.angle()
		target_scale = Vector2(1 + stretch, 1 - stretch)
	else:
		target_scale = Vector2.ONE

	if Input.is_action_just_pressed("space"):
		if RoomManager.current_room: RoomManager.current_room.camera.shake(0.1, 2)

	trail.emitting = not input == Vector2.ZERO

	move_and_slide()
