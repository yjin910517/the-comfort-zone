extends TextureButton

signal go_to_room(destination)

@export var destination: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("pressed", Callable(self, "_on_btn_pressed"))


func _on_btn_pressed():
	emit_signal("go_to_room", destination)
