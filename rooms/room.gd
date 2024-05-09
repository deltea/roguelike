class_name Room extends Node2D

@export var palette: PaletteResource

func _enter_tree():
	RoomManager.current_room = self
