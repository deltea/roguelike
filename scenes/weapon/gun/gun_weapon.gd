class_name GunWeapon extends Weapon

@export var bullet_speed = 400.0
@export var bullet_health = 1
@export var bullet_count = 1
@export var spread = 10.0
@export var fire_point_offset = 8.0
@export var player_knockback = 10.0
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

	var bullet = bullet_scene.instantiate() as Bullet
	var direction = (global_position - get_global_mouse_position()).normalized()
	bullet.rotation = direction.angle()
	bullet.global_position = global_position - (direction * fire_point_offset)
	bullet.speed = bullet_speed
	RoomManager.current_room.add_child(bullet)
