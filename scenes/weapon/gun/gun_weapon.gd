class_name GunWeapon extends Weapon

const bullet_speed = 400.0
const bullet_health = 1
const bullet_count = 1
const spread = 8.0
const fire_point_offset = 8.0
const player_knockback = 50.0
const fire_rate = 5.0
const max_magazine = 10
const reload_time = 1.0
@export var sound: AudioStream
@export var bullet_scene: PackedScene

@onready var reload_bar: Sprite2D = $ReloadBar
@onready var reload_indicator: Sprite2D = $ReloadBar/ReloadIndicator
@onready var muzzle_flash: Sprite2D = $MuzzleFlash

var next_time_to_fire = 0.0
var magazine = max_magazine
var is_reloading = false
var reload_timer = 0.0

func _ready() -> void:
	reload_bar.visible = false
	muzzle_flash.visible = false

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
		RoomManager.current_room.camera.shake(0.05, 1)

	muzzle_flash.position = -direction * 8
	flash_muzzle()

	magazine -= 1
	if magazine == 0:
		reload_timer = 0.0
		reload_bar.visible = true
		is_reloading = true

func flash_muzzle():
	muzzle_flash.visible = true
	await Clock.wait(0.065)
	muzzle_flash.visible = false
