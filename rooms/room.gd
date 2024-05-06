class_name Room extends Node2D

@export var palette: PaletteResource

func _enter_tree() -> void:
	RoomManager.room_entered.emit(self)
