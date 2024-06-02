class_name MissileBullet extends Bullet

const ROTATION_SPEED = 1.5

func _process(delta: float) -> void:
	rotation = lerp_angle(rotation, (position - RoomManager.current_room.player.position).angle(), ROTATION_SPEED * delta)
