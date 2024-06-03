class_name Gem extends Area2D

@export var max_health = 5
@export var impact_rotation = 15.0
@export var gem_pieces_scene: PackedScene

@onready var sprite: Sprite = $Sprite

var health = max_health
var direction = 1

func get_hurt(damage: int):
	health -= damage

	direction *= -1
	sprite.impact_scale(Vector2.ONE * 1.2)
	sprite.impact_rotation(impact_rotation * direction)

	if health <= 0:
		die()

func die():
	queue_free()
	var gem_pieces = gem_pieces_scene.instantiate()
	gem_pieces.global_position = global_position
	RoomManager.current_room.add_child(gem_pieces)

	Clock.hitstop(0.1)
	await Clock.wait(0.1)
	RoomManager.current_room.camera.shake(1.0, 50)

func _on_area_entered(area: Area2D):
	if area is Bullet:
		var bullet = area as Bullet
		get_hurt(bullet.damage)
		bullet.get_hit()
