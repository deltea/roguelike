class_name Coin extends Area2D

const spin_speed = 200.0

@onready var sprite: Sprite = $Sprite

var velocity = Vector2.ZERO

func _ready() -> void:
	velocity = Vector2.from_angle(randf() * PI*2) * 300.0

func _process(delta: float) -> void:
	sprite.target_rotation_degrees += spin_speed * delta
	global_position += velocity * delta
	velocity = velocity.lerp(Vector2.ZERO, 10 * delta)

func collect():
	sprite.target_scale = Vector2.ONE * 1.5
	await Clock.wait(0.2)
	sprite.target_scale = Vector2.ZERO
	await Clock.wait(0.05)

	queue_free()

func _on_body_entered(body: Node2D):
	if body is Player:
		collect()
