class_name Room extends Node2D

@export var palette: PaletteResource

var player: Player
var camer: Camera

func _enter_tree():
	RoomManager.current_room = self
