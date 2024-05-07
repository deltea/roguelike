extends CanvasLayer

@export var default_palette: PaletteResource

var palette: PaletteResource:
	get: return palette
	set(value):
		palette = value

func _enter_tree() -> void:
	RoomManager.room_entered.connect(_on_room_entered)

func _ready() -> void:
	set_palette(null)
	set_filter()

func set_filter():
	if !palette:
		printerr("🎨 No color palette provided for the current room! Set a default color palette or set a color palette for the room.")
		return

	RenderingServer.set_default_clear_color(palette.dark)

	$ColorRect.material.set_shader_parameter("new_dark", palette.dark)
	$ColorRect.material.set_shader_parameter("new_light", palette.light)
	$ColorRect.material.set_shader_parameter("new_primary", palette.primary)
	$ColorRect.material.set_shader_parameter("new_secondary", palette.secondary)
	$ColorRect.material.set_shader_parameter("new_accent", palette.accent)

func set_palette(room: Room):
	if room:
		palette = room.palette
	else:
		palette = default_palette

func _on_room_entered(room: Room):
	set_palette(room)
