extends Node

var all_upgrades: Array[UpgradeObject] = []
var current_upgrades: Array[UpgradeObject] = []
var starting_reroll_price = 5
var reroll_price = starting_reroll_price
var shop_slots = 3

signal upgrades_rerolled

func reroll_upgrades():
	print("rerolled!")
	reroll_price += 1
	upgrades_rerolled.emit()

func create_upgrade(upgrade_object: UpgradeObject):
	all_upgrades.push_back(upgrade_object)

func create_upgrades():
	create_upgrade(UpgradeObject.new("Stuff", load("res://assets/upgrades/upgrade.png")))
	create_upgrade(UpgradeObject.new("Stuff 3", load("res://assets/upgrades/upgrade-3.png")))
	create_upgrade(UpgradeObject.new("Stuff 2", load("res://assets/upgrades/upgrade-2.png")))

func buy_upgrade(upgrade):
	print("bought " + upgrade.name)
	current_upgrades.push_back(upgrade)

func activate_upgrades():
	for upgrade in current_upgrades:
		upgrade.activate()

# Upgrades
