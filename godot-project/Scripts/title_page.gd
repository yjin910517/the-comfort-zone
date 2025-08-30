extends Node2D

signal start_bgm()
signal go_to_room(destination_name)

@onready var start_button = $Button/ClickDetect
@onready var sleeping = $Sleeping


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.connect("gui_input", Callable(self, "_on_start_gui_input"))
	sleeping.hide()
	

func _on_start_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_start_sleeping()


func _start_sleeping():
	sleeping.show()
	start_button.hide() # sleeping doesn't have mouse filter?
	emit_signal("start_bgm")
	await get_tree().create_timer(3).timeout
	sleeping.hide()
	
	emit_signal("go_to_room", "spawn_room")
	hide()
