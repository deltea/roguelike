class_name Utils extends Node

static func random_direction():
	return Vector2.from_angle(deg_to_rad(randf_range(0, 360)))
