class_name GemPiece extends Sprite

@export var initial_velocity = 200.0
@export var velocity_damping = 10.0
@export var initial_angular_velocity = 200.0
@export var angular_velocity_damping = 10.0

@onready var timer: Timer = $Timer

var velocity = Vector2.ZERO
var angular_velocity = 0.0

func _ready() -> void:
	super._ready()

	velocity = position.normalized() * initial_velocity
	angular_velocity = initial_angular_velocity * (1 if randi() % 2 == 0 else -1)

	await Clock.wait(randf_range(0.5, 1.0))
	blink_out()

func _process(delta: float) -> void:
	super._process(delta)

	position += velocity * delta
	target_rotation_degrees += angular_velocity * delta

	velocity = velocity.lerp(Vector2.ZERO, velocity_damping * delta)
	angular_velocity = lerp(angular_velocity, 0.0, angular_velocity_damping * delta)
