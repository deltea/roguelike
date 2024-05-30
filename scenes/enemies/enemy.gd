class_name Enemy extends CharacterBody2D

@export var max_health = 3
@export var coin_drop_min = 0
@export var coin_drop_max = 1
@export var coin_scene: PackedScene

@onready var sprite: Sprite = $Sprite
@onready var collider: CollisionShape2D = $CollisionShape

var health = max_health
var knockback_velocity = Vector2.ZERO

var particles_scene = preload("res://particles/enemy-explosion.tscn")

func _process(delta: float) -> void:
	knockback_velocity = knockback_velocity.lerp(Vector2.ZERO, 10 * delta)

func get_hurt(damage: int):
	health -= damage

	if health <= 0:
		die()

	sprite.impact_scale(Vector2.ONE * 1.3)

	sprite.self_modulate = Color.WHITE
	await Clock.wait(0.1)
	sprite.self_modulate = Color.GREEN

func die():
	queue_free()

	Clock.hitstop(0.1)
	if RoomManager.current_room:
		RoomManager.current_room.camera.shake(0.05, 2)

	var particles = particles_scene.instantiate() as CPUParticles2D
	particles.global_position = global_position
	particles.emitting = true
	particles.finished.connect(particles.queue_free)
	RoomManager.current_room.add_child(particles)

	if coin_scene:
		for i in range(randi_range(coin_drop_min, coin_drop_max)):
			var coin = coin_scene.instantiate() as Coin
			coin.global_position = global_position
			coin.velocity = Vector2(randf() * 200 - 100, -100)
			if RoomManager.current_room:
				RoomManager.current_room.call_deferred("add_child", coin)
	else:
		printerr("🪙 No coin scene assigned to enemy")

func _on_hitbox_area_entered(area: Area2D):
	if area is Bullet:
		var bullet = area as Bullet
		knockback(Vector2.from_angle(bullet.rotation), 200)
		get_hurt(bullet.damage)
		bullet.get_hit()

func knockback(direction: Vector2, force: float):
	knockback_velocity = -direction.normalized() * force
