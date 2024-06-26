class_name Shop extends Node2D

var enemies: Array = []

func _ready() -> void:
	for child in enemies:
		child.set_disabled(true)

	var unpicked_upgrades = UpgradeManager.all_upgrades.duplicate()
	for child in get_children():
		if child is Gem:
			var random_upgrade = unpicked_upgrades.pick_random()
			child.upgrade = random_upgrade
			child.set_icon()
			unpicked_upgrades.remove_at(unpicked_upgrades.find(random_upgrade))

func gem_destroyed(gem: Gem):
	for child in enemies:
		child.set_disabled(false)

	var index = gem.get_index()

	for i in range(get_child_count()):
		if i == index: continue
		get_child(i).queue_free()
