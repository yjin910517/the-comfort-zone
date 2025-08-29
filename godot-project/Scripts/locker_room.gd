extends Node2D

signal token_delivered(room_name)
signal wake_up(wakeup_reason)
signal go_to_room(destination_name)
signal final_lock_check(room_node)

@onready var room_nav = $Nav
@onready var doors = $Doors
@onready var room1 = $Room1
@onready var token1 = $Room1/Token
@onready var room2 = $Room2
@onready var token2 = $Room2/Letter/Token
@onready var room3 = $Room3
@onready var button_room = $ButtonRoom
@onready var stay_btn = $ButtonRoom/NavStay
@onready var wake_btn = $ButtonRoom/NavWake
@onready var final_room = $FinalRoom

@onready var outcome_mapping = {
	"narrative_1": room1,
	"narrative_2": room2,
	"narrative_3": room3, 
	"button_room": button_room,
	"final_room": final_room
}

var DoorScene = preload("res://Scenes/Door.tscn")

var door_dataset = [
	{
		"texture": preload("res://Arts/locker_room/locker_single_frames1.png"),
		"outcome": "narrative_2"
	},
	{
		"texture": preload("res://Arts/locker_room/locker_single_frames2.png"),
		"outcome": "narrative_3"
	},
	{
		"texture": preload("res://Arts/locker_room/locker_single_frames3.png"),
		"outcome": "final_room"
	},
	{
		"texture": preload("res://Arts/locker_room/locker_single_frames4.png"),
		"outcome": "narrative_1"
	},
	{
		"texture": preload("res://Arts/locker_room/locker_single_frames5.png"),
		"outcome": "button_room"
	}
]

# use this for randomized door positions
var pos_set = [
	[
		Vector2(46,140),
		Vector2(236,90),
		Vector2(400,208),
		Vector2(580,120),
		Vector2(760,170)
	]
]

var chosen_pos_set = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_nav.connect("pressed", Callable(self, "_on_room_nav"))
	
	token1.connect("token_collected", Callable(self, "_on_token_collected"))
	token2.connect("token_collected", Callable(self, "_on_token_collected"))
	
	stay_btn.connect("pressed", Callable(self, "_on_stay_pressed"))
	wake_btn.connect("pressed", Callable(self, "_on_wake_pressed"))
	
	final_room.connect("lock_request", Callable(self, "_on_lock_request"))
	final_room.connect("unlocked", Callable(self, "_on_unlocked"))
	
	# initiate doors
	var new_pos = pos_set[chosen_pos_set]
	for idx in range(new_pos.size()):
		var new_door = DoorScene.instantiate()
		doors.add_child(new_door)
	
		var door_data = door_dataset[idx]
		door_data["position"] = new_pos[idx]
		new_door.set_door_data(door_data)
		
		new_door.connect("door_opened", Callable(self, "_on_door_opened"))
		
	room1.position = Vector2(0,0)
	room2.position = Vector2(0,0)
	room3.position = Vector2(0,0)
	button_room.position = Vector2(0,0)
	final_room.position = Vector2(0,0)
	
	room1.hide()
	room2.hide()
	room3.hide()
	button_room.hide()
	final_room.hide()
	

func _on_room_nav():
	emit_signal("go_to_room", room_nav.destination)
	hide()
	
	
func _on_door_opened(outcome):
	
	var new_room = outcome_mapping[outcome]
	new_room.show()
	
	# start the cloud animation
	if outcome == "narrative_1":
		new_room.start_room()
	
	# set up the lock display 
	if outcome == "final_room":
		new_room.start_room()


func _on_token_collected(token_node):
	emit_signal("token_delivered", "door_room")


func _on_stay_pressed():
	button_room.hide()
	

func _on_wake_pressed():
	button_room.hide()
	emit_signal("wake_up", "twilight")
	hide()


func _on_lock_request():
	emit_signal("final_lock_check", self)
		

func attempt_to_unlock(token_count):
	final_room.lock_check(token_count)
		

func _on_unlocked():
	emit_signal("go_to_room", "finale_room")
	hide()
