class_name Coin extends Area2D

const SPIN_SPEED = 200.0

@onready var sprite: Sprite = $Sprite

var velocity = Vector2.ZERO

func _ready() -> void:
	velocity = Vector2.from_angle(randf() * PI*2) * 400.0

func _process(delta: float) -> void:
	sprite.target_rotation_degrees += SPIN_SPEED * delta
	global_position += velocity * delta
	velocity = velocity.lerp(Vector2.ZERO, 5 * delta)

func collect():
	sprite.target_scale = Vector2.ONE * 1.5
	await Clock.wait(0.2)
	sprite.target_scale = Vector2.ZERO
	await Clock.wait(0.05)

	queue_free()

func _on_body_entered(body: Node2D):
	if body is Player:
		collect()
