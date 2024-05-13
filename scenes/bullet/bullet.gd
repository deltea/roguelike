class_name Bullet extends Area2D

var speed = 0.0
var health = 1

var particles_scene = preload("res://particles/explosion.tscn")

func _ready() -> void:
	if speed == 0.0:
		printerr("🚅 \"" + name + "\" bullet speed is not specified! Bullet will not move.")

func _physics_process(delta):
	position += Vector2.from_angle(rotation + PI) * speed * delta

func _on_body_entered(body: Node2D):
	if body is Walls:
		var particles = particles_scene.instantiate() as CPUParticles2D
		particles.global_position = global_position
		particles.emitting = true
		particles.finished.connect(particles.queue_free)
		particles.rotation_degrees = rotation_degrees
		RoomManager.current_room.add_child(particles)
		queue_free()
