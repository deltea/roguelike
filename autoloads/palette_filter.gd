extends CanvasLayer

@export var default_palette: PaletteResource

var palette: PaletteResource

func _ready() -> void:
	set_palette(RoomManager.current_room)
	set_filter()

func set_filter():
	if not palette:
		printerr("🎨 No color palette provided for the current room! Set a default color palette or set a color palette for the room.")
		return

	RenderingServer.set_default_clear_color(palette.dark)

	$ColorRect.material.set_shader_parameter("new_dark", palette.dark)
	$ColorRect.material.set_shader_parameter("new_light", palette.light)
	$ColorRect.material.set_shader_parameter("new_primary", palette.primary)
	$ColorRect.material.set_shader_parameter("new_secondary", palette.secondary)
	$ColorRect.material.set_shader_parameter("new_accent", palette.accent)

func set_palette(room: Room):
	palette = room.palette if room and room.palette else default_palette
