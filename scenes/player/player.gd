class_name Player extends CharacterBody2D

@export var move_speed = 100.0
@export var rotation_animation_speed = 20.0
@export var scale_animation_speed = 10.0
@export var stretch = 0.15

@onready var anchor: Node2D = $Anchor
@onready var sprite: Sprite2D = $Anchor/Sprite2D

var target_rotation = 0.0
var target_scale = Vector2.ONE

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

	move_and_slide()
