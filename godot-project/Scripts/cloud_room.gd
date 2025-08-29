extends Node2D

@onready var cloud1 = $Cloud1
@onready var cloud2 = $Cloud2
@onready var cloud3 = $Cloud3
@onready var cloud4 = $Cloud4


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

# reset animations to play from the beginning
func start_room():
	cloud1.get_node("AnimationPlayer").stop()
	cloud2.get_node("AnimationPlayer").stop()
	cloud3.get_node("AnimationPlayer").stop()
	cloud4.get_node("AnimationPlayer").stop()
	cloud1.get_node("AnimationPlayer").play("float")
	cloud2.get_node("AnimationPlayer").play("float")
	cloud3.get_node("AnimationPlayer").play("float")
	cloud4.get_node("AnimationPlayer").play("float")
