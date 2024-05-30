class_name GunWeapon extends Weapon

const BULLET_SPEED = 400.0
const BULLET_HEALTH = 1
const BULLET_COUNT = 1
const BULLET_DAMAGE = 1
const SPREAD = 8.0
const FIRE_POINT_OFFSET = 8.0
const PLAYER_KNOCKBACK = 50.0
const FIRE_RATE = 5.0
const MAX_MAGAZINE = 10
const RELOAD_TIME = 1.0
@export var sound: AudioStream
@export var bullet_scene: PackedScene

@onready var reload_bar: Sprite2D = $ReloadBar
@onready var reload_indicator: Sprite2D = $ReloadBar/ReloadIndicator
@onready var muzzle_flash: Sprite2D = $MuzzleFlash

var next_time_to_fire = 0.0
var magazine = MAX_MAGAZINE
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
		reload_indicator.position.x = reload_timer / RELOAD_TIME * 14 - 7
		if reload_timer >= RELOAD_TIME:
			magazine = MAX_MAGAZINE
			reload_bar.visible = false
			is_reloading = false

func fire():
	if not bullet_scene:
		printerr("🚅 No bullet scene specified! Bullet will not spawn.")
		return

	next_time_to_fire = Clock.time + 1.0 / FIRE_RATE

	var direction = (global_position - get_global_mouse_position()).normalized()
	var step = SPREAD / BULLET_COUNT
	var half_spread = SPREAD / 2

	for i in range(BULLET_COUNT):
		var bullet = bullet_scene.instantiate() as Bullet

		if BULLET_COUNT > 1:
			bullet.rotation_degrees = rad_to_deg(direction.angle()) + i * step - (half_spread - half_spread / BULLET_COUNT)
		else:
			var random_spread = deg_to_rad(randf_range(-SPREAD, SPREAD))
			bullet.rotation = direction.angle() + random_spread

		bullet.global_position = global_position - (Vector2.from_angle(bullet.rotation) * FIRE_POINT_OFFSET)
		bullet.damage = BULLET_DAMAGE
		bullet.speed = BULLET_SPEED
		bullet.health = BULLET_HEALTH

		if RoomManager.current_room: RoomManager.current_room.add_child(bullet)

	if RoomManager.current_room:
		RoomManager.current_room.player.knockback(direction, PLAYER_KNOCKBACK)
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
