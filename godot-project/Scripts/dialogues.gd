extends Node2D

signal dialogue_ended()

@onready var p1 = $P1
@onready var p2 = $P2
@onready var p3 = $P3
@onready var p4 = $P4
@onready var p5 = $P5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	p1.hide()
	p2.hide()
	p3.hide()
	p4.hide()
	p5.hide()


func start_dialogue():
	await get_tree().create_timer(2).timeout
	# enter greeting
	p1.show()
	await get_tree().create_timer(3).timeout
	
	# enter open line
	p2.show()
	await get_tree().create_timer(3).timeout
	
	# enter 1st paragraph
	p3.get_node("AnimationPlayer").play("fade_in")
	await get_tree().create_timer(0.1).timeout
	p3.show()
	await get_tree().create_timer(8).timeout
	
	# enter 2nd paragraph
	p4.get_node("AnimationPlayer").play("fade_in")
	await get_tree().create_timer(0.1).timeout
	p4.show()
	await get_tree().create_timer(5).timeout
	
	# final word
	p5.show()
	await get_tree().create_timer(3).timeout
	
	emit_signal("dialogue_ended")
