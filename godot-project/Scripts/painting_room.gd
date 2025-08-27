extends Node2D


signal token_delivered(room_name)
signal go_to_room(destination_name)

@export var room_name: String

@onready var wall_view = $WallView
@onready var room_nav = $WallView/Nav
@onready var token = $WallView/Wave/Token
@onready var mirror_click = $WallView/Mirror/ClickDetect
@onready var arcade_click = $WallView/Arcade/ClickDetect

@onready var mirror_entry = $MirrorEntry
@onready var door_click = $MirrorEntry/Mirror/DoorClick

var token_collected = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	room_nav.connect("pressed", Callable(self, "_on_room_nav"))
	
	token.connect("token_collected", Callable(self, "_on_painting_token_collected"))
	mirror_click.connect("gui_input", Callable(self, "_on_mirror_gui_input"))
	arcade_click.connect("gui_input", Callable(self, "_on_arcade_gui_input"))
	door_click.connect("gui_input", Callable(self, "_on_door_gui_input"))
	
	wall_view.position = Vector2(0,0)
	mirror_entry.position = Vector2(0,0)
	
	wall_view.show()
	mirror_entry.hide()


func _on_room_nav():
	emit_signal("go_to_room", room_nav.destination)
	hide()
	

func _on_painting_token_collected(token_node):
	token_collected = true
	emit_signal("token_delivered", "painting_room")
	

func _on_mirror_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		mirror_entry.show()
		

func _on_door_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("go_to_room", "door_room")
		mirror_entry.hide()
		hide()
		
		
func _on_arcade_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("go_to_room", "arcade_room")
		hide()
