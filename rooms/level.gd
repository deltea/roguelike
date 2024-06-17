class_name Level extends Room

@export var shop_scene: PackedScene

@onready var enemies: Node2D = $Enemies

var xp_needed = 1
var xp = 0

func add_xp(amount: int):
	xp += amount

	if xp >= xp_needed:
		# upgrade
		xp = 0
		xp_needed += 1

		open_shop()

func open_shop():
	var shop = shop_scene.instantiate() as Shop
	shop.enemies = enemies.get_children()

	add_child(shop)
