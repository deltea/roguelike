class_name Level extends Room

func _ready() -> void:
	$Model.texture = $SubViewport.get_texture()