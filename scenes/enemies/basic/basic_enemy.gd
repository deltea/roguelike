class_name BasicEnemy extends Enemy

const spin_speed = 200.0
const move_speed = 25.0

var spin_direction = 1

func _process(delta: float) -> void:
	super._process(delta)

	sprite.target_rotation_degrees += spin_speed * spin_direction * delta
	if RoomManager.current_room:
		var direction = (RoomManager.current_room.player.global_position - global_position).normalized()
		velocity = direction * move_speed + knockback_velocity

	move_and_slide()

func get_hurt(damage: int):
	super.get_hurt(damage)

	spin_direction *= -1
