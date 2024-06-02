class_name MissileEnemy extends Enemy

const SPIN_SPEED = 100.0
const MOVE_SPEED = 10.0
const BULLET_SPEED = 120.0
const FIRE_OFFSET = 0.0
const FIRE_DELAY = 1.0

@export var bullet_scene: PackedScene

@onready var fire_timer: Timer = $FireTimer

var is_moving = true

func _ready() -> void:
	await Clock.wait(randf_range(0, fire_timer.wait_time))
	fire_timer.start()

func _process(delta: float) -> void:
	super._process(delta)

	if is_moving:
		sprite.target_rotation_degrees += SPIN_SPEED * delta
		var direction = (RoomManager.current_room.player.global_position - global_position).normalized()
		velocity = direction * MOVE_SPEED + knockback_velocity

		move_and_slide()

func _on_fire_timer_timeout():
	is_moving = false
	await Clock.wait(FIRE_DELAY)

	var bullet = bullet_scene.instantiate() as MissileBullet
	bullet.global_position = global_position + Vector2.from_angle(rotation) * FIRE_OFFSET
	bullet.rotation = rotation
	bullet.speed = BULLET_SPEED
	RoomManager.current_room.add_child(bullet)

	await Clock.wait(FIRE_DELAY)
	is_moving = true
