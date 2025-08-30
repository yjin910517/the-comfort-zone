extends Node2D

signal token_delivered(room_name)

@onready var dialogue_box = $Dialogues
@onready var token = $Token

func _ready() -> void:
	
	dialogue_box.connect("dialogue_ended", Callable(self, "_on_dialogue_ended"))
	token.connect("token_collected", Callable(self, "_on_finale_token_collected"))
	
	token.hide()
	
	
func start_finale_scene():
	dialogue_box.start_dialogue()


func _on_dialogue_ended():
	token.show()
	token.play("finale")
	
	
func _on_finale_token_collected(token):
	emit_signal("token_delivered", "finale_room")
	hide()
