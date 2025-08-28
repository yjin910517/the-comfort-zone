extends Node2D

@onready var spawn_room = $SpawnRoom
@onready var cliff_room = $CliffRoom
@onready var painting_room = $PaintingRoom
@onready var arcade_room = $ArcadeRoom
@onready var counter = $TokenCounter
@onready var wakeup_scene = $WakeUp

@onready var node_mapping = {
	"spawn_room": spawn_room,
	"cliff_room": cliff_room,
	"painting_room": painting_room,
	"arcade_room": arcade_room,
	# test
	"door_room": cliff_room,
	"locker_room": cliff_room,
	"finale_room": 0
}

# token variables
var token_count = 0
var token_collection = {
	"spawn_room": 0,
	"cliff_room": 0,
	"painting_room": 0,
	"arcade_room": 0,
	"door_room": 0,
	"locker_room": 0,
	"finale_room": 0
}

# wake up variables
var has_woke_up = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_room.connect("token_delivered", Callable(self, "_on_token_delivered"))
	spawn_room.connect("go_to_room", Callable(self, "_on_room_changed"))
	
	cliff_room.connect("token_delivered", Callable(self, "_on_token_delivered"))
	cliff_room.connect("go_to_room", Callable(self, "_on_room_changed"))
	cliff_room.connect("wake_up", Callable(self, "_on_wake_up"))

	painting_room.connect("token_delivered", Callable(self, "_on_token_delivered"))
	painting_room.connect("go_to_room", Callable(self, "_on_room_changed"))
	
	arcade_room.connect("token_delivered", Callable(self, "_on_token_delivered"))
	arcade_room.connect("go_to_room", Callable(self, "_on_room_changed"))
	arcade_room.connect("wake_up", Callable(self, "_on_wake_up"))
	
	wakeup_scene.connect("sleep_again", Callable(self, "_on_sleep_again"))

	spawn_room.position = Vector2(0,0)
	cliff_room.position = Vector2(0,0)
	painting_room.position = Vector2(0,0)
	arcade_room.position = Vector2(0,0)
	wakeup_scene.position = Vector2(0,0)
	
	# test
	spawn_room.show()
	
	cliff_room.hide()
	painting_room.hide()
	arcade_room.hide()
	
	wakeup_scene.hide()
	
	
func _on_token_delivered(room_name):
	token_collection[room_name] += 1
	token_count += 1
	print("total count: ", token_count)
	counter.update_token_display(token_count)
	
	
func _on_room_changed(destination):
	var new_room = node_mapping[destination]
	new_room.show()


func _on_wake_up(reason):

	if has_woke_up == false:
		has_woke_up = true
		spawn_room.update_spawn_view()
		
	print("waking up by ", reason)
	# to do: free black screen for 1 second 
	# to do: sound effect
	
	var wakeup_data = {
		"count": token_count,
		"reason": reason
	}
	
	wakeup_scene.show_wakeup_scene(wakeup_data)
	

func _on_sleep_again():
	spawn_room.start_room()
	spawn_room.show()
