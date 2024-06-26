class_name Gem extends Area2D

@export var max_health = 5
@export var impact_rotation = 25.0
@export var gem_pieces_scene: PackedScene 

@onready var sprite: Sprite = $Sprite
@onready var icon: Sprite = $Icon

var health = max_health
var direction = 1
var upgrade: UpgradeObject

var particles_scene = preload ("res://particles/gem_explosion.tscn")

func get_hurt(damage: int):
	health -= damage

	direction *= -1
	sprite.impact_scale(Vector2.ONE * 1.2)
	sprite.impact_rotation(impact_rotation * direction)

	var particles = particles_scene.instantiate() as CPUParticles2D
	particles.global_position = global_position
	particles.emitting = true
	particles.finished.connect(particles.queue_free)
	RoomManager.current_room.add_child(particles)

	if health <= 0:
		die()

func die():
	queue_free()
	var gem_pieces = gem_pieces_scene.instantiate()
	gem_pieces.global_position = global_position

	get_parent().gem_destroyed(self)

	RoomManager.current_room.add_child(gem_pieces)

	# Clock.hitstop(0.1)
	# await Clock.wait(0.1)
	RoomManager.current_room.camera.shake(0.1, 5)

func set_icon():
	icon.texture = upgrade.icon

func _on_area_entered(area: Area2D):
	if area is Bullet:
		var bullet = area as Bullet
		get_hurt(bullet.damage)
		bullet.get_hit()
