class_name Level extends Room

@export var shop_scene: PackedScene

var xp_needed = 1
var xp = 0

func add_xp(amount: int):
	xp += amount

	if xp >= xp_needed:
		# upgrade
		xp = 0
		xp_needed += 1

		var shop = shop_scene.instantiate()
		add_child(shop)
