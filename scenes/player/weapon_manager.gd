class_name WeaponManager extends Node2D

var weapon: Weapon

func _ready() -> void:
	for child in get_children():
		if child is Weapon:
			weapon = child
			break

func _process(_delta: float) -> void:
	if not weapon: return

	weapon.is_using = Input.is_action_pressed("mouse_left")
	if Input.is_action_just_pressed("mouse_left"):
		weapon.use.emit()
