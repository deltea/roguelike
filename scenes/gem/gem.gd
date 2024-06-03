class_name Gem extends Area2D

@export var max_health = 5
@export var impact_rotation = 15.0

@onready var sprite: Sprite = $Sprite

var health = max_health
var direction = 1

func get_hurt(damage: int):
	health -= damage

	sprite.impact_scale(Vector2.ONE * 1.2)
	sprite.impact_rotation(impact_rotation * direction)
	direction *= -1

	if health <= 0:
		die()

func die():
	queue_free()
	print("Gem died")

	Clock.hitstop(0.1)
	await Clock.wait(0.1)
	RoomManager.current_room.camera.shake(1.0, 50)

func _on_area_entered(area: Area2D):
	if area is Bullet:
		var bullet = area as Bullet
		get_hurt(bullet.damage)
		bullet.get_hit()
