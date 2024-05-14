class_name Card extends Control

@export var snap_speed = 20.0
@export var inertia_speed = 10.0
@export var inertia_magnitude = 2.0

@onready var card: TextureButton = $CardButton

var original_pos = Vector2.ZERO
var target_pos = Vector2.ZERO
var mouse_offset = Vector2.ZERO
var inertia = Vector2.ZERO
var prev_mouse_pos = Vector2.ZERO

func _process(delta: float) -> void:
	if card.button_pressed:
		target_pos = get_local_mouse_position() - (card.size / 2) + mouse_offset
		card.position = card.position.lerp(target_pos, snap_speed * delta)

		inertia = get_local_mouse_position() - prev_mouse_pos
		prev_mouse_pos = get_local_mouse_position()
	else:
		card.position = card.position.lerp(original_pos, snap_speed * delta)

	card.rotation_degrees = lerp(card.rotation_degrees, inertia.x * inertia_magnitude, inertia_speed * delta)

func _on_card_button_button_down():
	mouse_offset = (global_position + card.size / 2) - get_global_mouse_position()
	card.pivot_offset = get_local_mouse_position()
	print(card.pivot_offset)

func _on_card_button_button_up():
	inertia = Vector2.ZERO

func _on_card_button_mouse_entered():
	pass

func _on_card_button_mouse_exited():
	pass
