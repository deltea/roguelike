class_name PaletteFilter extends CanvasLayer

@export var default_palette: PaletteResource

var palette: PaletteResource

func _ready() -> void:
	RoomManager.room_entered.connect(_on_room_entered)

func _on_room_entered(room: Room):
	if room.palette:
		palette = room.palette
	else:
		palette = default_palette
