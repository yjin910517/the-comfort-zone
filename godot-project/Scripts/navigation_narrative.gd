extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("pressed", Callable(self, "_on_pressed"))


func _on_pressed():
	get_parent().hide()
