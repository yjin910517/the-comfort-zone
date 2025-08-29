extends AnimatedSprite2D

@onready var audio = $AudioStreamPlayer2D
@onready var token = $Token
@onready var click_detect = $ClickDetect

var current_frame = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	click_detect.connect("gui_input", Callable(self, "_on_letter_gui_input"))
	
	self.frame = current_frame
	token.hide()


func _on_letter_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		current_frame += 1
		self.frame = current_frame
		audio.play()
		
		# reveal token in the envelope
		if current_frame == 2:
			click_detect.queue_free()
			token.show()
			
		
