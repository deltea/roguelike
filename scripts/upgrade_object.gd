class_name UpgradeObject extends Object

var name = ""
var icon: Texture2D
var method: Callable

func _init(name: String, icon: Texture2D, method: Callable = func(): pass) -> void:
	self.name = name
	self.icon = icon
	self.method = method

func activate():
	print("activated " + name)
	method.call()
