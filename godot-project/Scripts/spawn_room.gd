extends Node2D

signal token_delivered(room_name)
signal go_to_room(path_dict)

@export var room_name: String

@onready var spawn_view = $SpawnView
@onready var spawn_bg = $SpawnView/Background
@onready var nav0 = $SpawnView/Nav0

@onready var tutorial_view = $TutorialView
@onready var tutorial_bg = $TutorialView/Background
@onready var tutorial_text = $TutorialView/Notes
@onready var token = $TutorialView/Token
@onready var nav1 = $TutorialView/Nav1
@onready var nav2 = $TutorialView/Nav2

@onready var corridor = $Corridor
@onready var nav3 = $Corridor/Nav3
@onready var door1 = $Corridor/DoorClick1
@onready var door2 = $Corridor/DoorClick2

# for navigations
@onready var node_mapping = {
	"spawn": spawn_view,
	"tutorial": tutorial_view,
	"corridor": corridor
}

var token_collected = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	token.connect("token_collected", Callable(self, "_on_spawn_token_collected"))
	
	# connect the in-room navigations here
	nav0.connect("go_to_view", Callable(self, "_on_view_navigation"))
	nav1.connect("go_to_view", Callable(self, "_on_view_navigation"))
	nav2.connect("go_to_view", Callable(self, "_on_view_navigation"))
	nav3.connect("go_to_view", Callable(self, "_on_view_navigation"))
	
	# define the room to room pathway here
	door1.connect("gui_input", Callable(self, "_on_cliff_door_input"))
	door2.connect("gui_input", Callable(self, "_on_painting_door_input"))

	spawn_view.position = Vector2(0,0)
	tutorial_view.position = Vector2(0,0)
	corridor.position = Vector2(0,0)
	
	tutorial_text.hide()
	
	start_room()
	

# start the room when wake up / sleep again
func start_room():
	spawn_view.show()
	tutorial_view.hide()
	corridor.hide()


# after the first wakeup, the view changes
func update_spawn_view():
	spawn_bg.play("spawn_again")
	

# navigation inside spawn area
func _on_view_navigation(path_dict):
	var from_node = node_mapping[path_dict["from"]]
	var to_node = node_mapping[path_dict["to"]]
	
	if path_dict["from"] != "spawn":
		from_node.hide()
	
	to_node.show()
		
	
func _on_spawn_token_collected(token_node):
	token_collected = true
	# update wall visuals
	tutorial_bg.frame = 1
	tutorial_text.show()
	
	emit_signal("token_delivered", "spawn_room")


func _on_cliff_door_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("go_to_room", "cliff_room")
		hide()


func _on_painting_door_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("go_to_room", "painting_room")
		hide()
