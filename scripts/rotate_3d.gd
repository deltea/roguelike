extends Node3D

@export var rotation_speed = 2.0

func _process(delta: float) -> void:
	rotate_y(rotation_speed * delta)
