class_name BasicEnemy extends Enemy

const SPIN_SPEED = 200.0
const MOVE_SPEED = 25.0

var spin_direction = 1

func _process(delta: float) -> void:
	super._process(delta)

	if disabled: return

	sprite.target_rotation_degrees += SPIN_SPEED * spin_direction * delta
	var direction = (RoomManager.current_room.player.global_position - global_position).normalized()
	velocity = direction * MOVE_SPEED + knockback_velocity

	move_and_slide()

func get_hurt(damage: int):
	super.get_hurt(damage)

	spin_direction *= -1
