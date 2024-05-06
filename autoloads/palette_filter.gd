extends CanvasLayer

@export var default_palette: PaletteResource

var palette: PaletteResource:
	get: return palette
	set(value):
		palette = value

func _enter_tree() -> void:
	RoomManager.room_entered.connect(_on_room_entered)

func _ready() -> void:
	update_palette()

func update_palette():
	RenderingServer.set_default_clear_color(palette.dark)

	$ColorRect.material.set_shader_parameter("new_dark", palette.dark)
	$ColorRect.material.set_shader_parameter("new_light", palette.light)
	$ColorRect.material.set_shader_parameter("new_primary", palette.primary)
	$ColorRect.material.set_shader_parameter("new_secondary", palette.secondary)
	$ColorRect.material.set_shader_parameter("new_accent", palette.accent)

func _on_room_entered(room: Room):
	if room.palette:
		palette = room.palette
	else:
		palette = default_palette
