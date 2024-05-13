class_name UpgradeObject extends Object

var name = ""
var picture: Texture2D
var method: Callable

func _init(name: String, picture: Texture2D, method: Callable = func(): pass) -> void:
	self.name = name
	self.picture = picture
	self.method = method

func activate():
	print("activated " + name)
	method.call()
