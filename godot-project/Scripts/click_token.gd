extends AnimatedSprite2D


signal token_collected(token_node)


@onready var audio = $AudioStreamPlayer2D
@onready var click_control = $ClickControl

var _collected = false


func _ready() -> void:
	
	click_control.connect("gui_input", Callable(self, "_on_token_gui_input"))
	# to do: add token to group "tokens" for easy connection to main


func _on_token_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("token_collected", self)
		# audio.play()
		
		_collected = true
		hide()
