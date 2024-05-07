extends Node

func wait(duration: float):
	await get_tree().create_timer(duration, false, false, true).timeout
