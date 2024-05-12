class_name Bullet extends Area2D

var speed = 0.0
var health = 1

func _ready() -> void:
	if speed == 0.0:
		printerr("🚅 \"" + name + "\" bullet speed is not specified! Bullet will not move.")

func _physics_process(delta):
	position += Vector2.from_angle(rotation + PI) * speed * delta
