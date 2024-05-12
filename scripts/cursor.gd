class_name Cursor extends TextureRect

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func _process(_delta: float) -> void:
	position = get_global_mouse_position() - size/2

	if Input.is_action_just_pressed("esc"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_action_just_pressed("mouse_left"):
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
