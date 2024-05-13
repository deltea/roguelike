class_name GunWeapon extends Weapon

@export var bullet_speed = 400.0
@export var bullet_health = 1
@export var bullet_count = 1
@export var spread = 10.0
@export var fire_point_offset = 8.0
@export var player_knockback = 50.0
@export var fire_rate = 5.0
@export var sound: AudioStream
@export var bullet_scene: PackedScene

var next_time_to_fire = 0.0

func _process(_delta: float) -> void:
	if is_using and Clock.time >= next_time_to_fire:
		fire()

func fire():
	if not bullet_scene:
		printerr("🚅 No bullet scene specified! Bullet will not spawn.")
		return

	next_time_to_fire = Clock.time + 1.0 / fire_rate

	var direction = (global_position - get_global_mouse_position()).normalized()
	var step = spread / bullet_count
	var half_spread = spread / 2

	for i in range(bullet_count):
		var bullet = bullet_scene.instantiate() as Bullet

		if bullet_count > 1:
			bullet.rotation_degrees = rad_to_deg(direction.angle()) + i * step - (half_spread - half_spread / bullet_count)
		else:
			var random_spread = deg_to_rad(randf_range(-spread, spread))
			bullet.rotation = direction.angle() + random_spread

		bullet.global_position = global_position - (Vector2.from_angle(bullet.rotation) * fire_point_offset)
		bullet.speed = bullet_speed
		bullet.health = bullet_health

		if RoomManager.current_room: RoomManager.current_room.add_child(bullet)

	if RoomManager.current_room:
		RoomManager.current_room.player.knockback(direction, player_knockback)
