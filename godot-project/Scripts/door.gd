extends Node2D


signal door_opened(outcome)


@onready var sprite = $Sprite2D
@onready var click_detect = $Sprite2D/ClickDetect


var outcome


# test
var test_data = {
	"texture": preload("res://Arts/door_room/door2.png"),
	"position": Vector2(0,0),
	"outcome": "memory"
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	click_detect.connect("gui_input", Callable(self, "_on_door_gui_input"))
	
	# test
	# set_door_data(test_data)


func set_door_data(new_data):
	sprite.texture = new_data["texture"]
	position = new_data["position"]
	outcome =new_data["outcome"]
	click_detect.size = sprite.texture.get_size() * sprite.scale


# emit signal when door is opened (clicked)
func _on_door_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("door opening")
		print(name)
		emit_signal("door_opened", outcome)
