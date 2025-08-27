extends AnimatedSprite2D

@onready var click_detect = $ClickDetect


func _ready() -> void:
	click_detect.connect("gui_input", Callable(self, "_on_painting_gui_input"))


func _on_painting_gui_input(event):
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# toggle between two frames
		var current_frame = frame
		frame = 1 - current_frame
