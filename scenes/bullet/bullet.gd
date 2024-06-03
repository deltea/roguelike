class_name Bullet extends Area2D

@onready var sprite: Sprite = $Sprite

var speed = 0.0
var health = 1
var damage = 1

var particles_scene = preload("res://particles/explosion.tscn")

func _ready() -> void:
	if speed == 0.0:
		printerr("🚅 \"" + name + "\" bullet speed is not specified! Bullet will not move.")

func _physics_process(delta):
	position += Vector2.from_angle(rotation + PI) * speed * delta

func get_hit():
	health -= 1
	if health <= 0:
		var particles = particles_scene.instantiate() as CPUParticles2D
		particles.global_position = global_position
		particles.emitting = true
		particles.finished.connect(particles.queue_free)
		particles.rotation_degrees = rotation_degrees
		particles.color = sprite.self_modulate
		RoomManager.current_room.add_child(particles)
		queue_free()

func _on_body_entered(body: Node2D):
	if body is Walls:
		var particles = particles_scene.instantiate() as CPUParticles2D
		particles.global_position = global_position
		particles.emitting = true
		particles.finished.connect(particles.queue_free)
		particles.rotation_degrees = rotation_degrees
		particles.color = sprite.self_modulate
		RoomManager.current_room.add_child(particles)
		queue_free()
