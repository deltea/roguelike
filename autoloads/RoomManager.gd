extends Node

signal room_entered(room: Room)

var current_room: Room

func _on_room_entered(room: Room) -> void:
	current_room = room
