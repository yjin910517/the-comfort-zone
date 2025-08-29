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
@onready var token2 = $Room2/Token
@onready var room3 = $Room3
@onready var button_room = $ButtonRoom
@onready var stay_btn = $ButtonRoom/NavStay
@onready var wake_btn = $ButtonRoom/NavWake
@onready var final_room = $FinalRoom
@onready var final_tunnel = $FinalRoom/Background
@onready var final_lock = $FinalRoom/LockIcon
@onready var lock_click = $FinalRoom/LockIcon/ClickDetect

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
		"texture": preload("res://Arts/door_room/door1.png"),
		"outcome": "narrative_1"
	},
	{
		"texture": preload("res://Arts/door_room/door2.png"),
		"outcome": "narrative_2"
	},
	{
		"texture": preload("res://Arts/door_room/door3.png"),
		"outcome": "final_room"
	},
	{
		"texture": preload("res://Arts/door_room/door4.png"),
		"outcome": "button_room"
	},
	{
		"texture": preload("res://Arts/door_room/door5.png"),
		"outcome": "narrative_3"
	}
]

# use this for randomized door positions
var pos_set = [
	[
		Vector2(40,168),
		Vector2(236,63),
		Vector2(450,208),
		Vector2(602,63),
		Vector2(773,178)
	]
]

var chosen_pos_set = 0

var is_locked = true

const LOCK_COST = 6


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_nav.connect("pressed", Callable(self, "_on_room_nav"))
	
	token1.connect("token_collected", Callable(self, "_on_token_collected"))
	token2.connect("token_collected", Callable(self, "_on_token_collected"))
	
	stay_btn.connect("pressed", Callable(self, "_on_stay_pressed"))
	wake_btn.connect("pressed", Callable(self, "_on_wake_pressed"))
	
	lock_click.connect("gui_input", Callable(self, "_on_lock_gui_input"))
	
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
	
	outcome_mapping[outcome].show()
	
	if outcome == "final_room" and is_locked:
		final_lock.hide()
		final_tunnel.play("final_room_locked")
		await get_tree().create_timer(1).timeout
		final_lock.show()


func _on_token_collected(token_node):
	emit_signal("token_delivered", "door_room")


func _on_stay_pressed():
	button_room.hide()
	

func _on_wake_pressed():
	button_room.hide()
	emit_signal("wake_up", "twilight")
	hide()


func _on_lock_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("final_lock_check", self)


func attempt_to_unlock(token_count):
	if token_count >= LOCK_COST:
		is_locked = false
		print("final room unlocked")
		# hide nav back arrow
		# play unlock anime
		# freeze click action
		# await timer for anime play
		# unfreeze click action
		# send go to room signal to main
		# change room content to static
		# resume hidden nav arrow
		# final_room.hide()
		# hide()
	else:
		print("not enough token")
		# hide nav back arrow
		# freeze click action
		# play lock anime
		# await timer for anime play
		# unfreeze click action
		# resume hidden nav arrow
