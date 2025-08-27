extends TextureButton

signal go_to_view(path_dict)

@export var location: String
@export var destination: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("pressed", Callable(self, "_on_btn_pressed"))


func _on_btn_pressed():
	var path_dict = {
		"from": location,
		"to": destination
	}
	emit_signal("go_to_view", path_dict)
