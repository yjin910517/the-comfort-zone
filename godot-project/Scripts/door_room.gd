extends Node2D



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
		"outcome": "memory"
	},
	{
		"texture": preload("res://Arts/door_room/door4.png"),
		"outcome": "room"
	},
	{
		"texture": preload("res://Arts/door_room/door5.png"),
		"outcome": "awake"
	}
]

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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var new_pos = pos_set[chosen_pos_set]
	for idx in range(new_pos.size()):
		var new_door = DoorScene.instantiate()
		add_child(new_door)
	
		var door_data = door_dataset[idx]
		door_data["position"] = new_pos[idx]
		new_door.set_door_data(door_data)
