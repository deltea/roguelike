class_name Enemy extends CharacterBody2D

@export var max_health = 3000

@onready var sprite: Sprite = $Sprite
@onready var collider: CollisionShape2D = $CollisionShape

var health = max_health
var knockback_velocity = Vector2.ZERO

func _process(delta: float) -> void:
	knockback_velocity = knockback_velocity.lerp(Vector2.ZERO, 10 * delta)

func get_hurt(damage: int):
	health -= damage

	if health <= 0:
		queue_free()

	sprite.impact_scale(Vector2.ONE * 1.3)
	if RoomManager.current_room:
		RoomManager.current_room.camera.shake(0.05, 1.5)

	sprite.self_modulate = Color.BLUE
	await Clock.wait(0.1)
	sprite.self_modulate = Color.GREEN

func _on_hitbox_area_entered(area: Area2D):
	if area is Bullet:
		var bullet = area as Bullet
		knockback(Vector2.from_angle(bullet.rotation), 200)
		get_hurt(bullet.damage)
		bullet.get_hit()

func knockback(direction: Vector2, force: float):
	knockback_velocity = -direction.normalized() * force
