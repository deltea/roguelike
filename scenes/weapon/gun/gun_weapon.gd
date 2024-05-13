class_name GunWeapon extends Weapon

@export var bullet_speed = 400.0
@export var bullet_health = 1
@export var bullet_count = 1
@export var spread = 10.0
@export var fire_point_offset = 8.0
@export var player_knockback = 50.0
@export var fire_rate = 5.0
@export var max_magazine = 5
@export var reload_time = 1.0
@export var sound: AudioStream
@export var bullet_scene: PackedScene

@onready var reload_bar: Sprite2D = $ReloadBar
@onready var reload_indicator: Sprite2D = $ReloadBar/ReloadIndicator

var next_time_to_fire = 0.0
var magazine = max_magazine
var is_reloading = false
var reload_timer = 0.0

func _ready() -> void:
	reload_bar.visible = false

func _process(delta: float) -> void:
	if is_using and Clock.time >= next_time_to_fire and not is_reloading:
		fire()

	if is_reloading:
		reload_timer += delta
		reload_indicator.position.x = reload_timer / reload_time * 14 - 7
		if reload_timer >= reload_time:
			magazine = max_magazine
			reload_bar.visible = false
			is_reloading = false

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

	magazine -= 1
	if magazine == 0:
		reload_timer = 0.0
		reload_bar.visible = true
		is_reloading = true
