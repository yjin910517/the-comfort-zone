extends Node2D

signal sleep_again()

@onready var normal_scene = $WakeUpNormal
@onready var sleep_btn1 = $WakeUpNormal/SleepBtn

@onready var special_scene = $WakeUpSpecial
@onready var sleep_btn2 = $WakeUpSpecial/SleepBtn

@onready var complete_scene = $WakeUpComplete

const TOTAL_TOKEN = 8

var wakeup_notes = {
	"easy": "Difficult roads lead to beautiful destinations (Easy ones wake you up)",
	"fall": "Never Lose Faith. Try it again (and again).",
	"door": "xxxxxx"
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sleep_btn1.connect("pressed", Callable(self, "_on_sleep_again"))
	sleep_btn2.connect("pressed", Callable(self, "_on_sleep_again"))


func show_wakeup_scene(wakeup_data):
	
	# hide everything first
	normal_scene.hide()
	special_scene.hide()
	complete_scene.hide()
	
	var token_count = wakeup_data["count"]
	var wakeup_reason = wakeup_data["reason"]
	
	# show the normal wake up scene 
	if wakeup_reason != "final":
		normal_scene.get_node("Progress/Label").text = str(token_count) + "/" + str(TOTAL_TOKEN) + " Collected"
		normal_scene.get_node("Notes/Label").text = wakeup_notes[wakeup_reason]
		normal_scene.show()
	
	# show the special wake up scene when final room unlocked
	elif token_count < TOTAL_TOKEN:
		special_scene.get_node("Progress/Label").text = str(token_count) + "/" + str(TOTAL_TOKEN) + " Collected"
		special_scene.show()
	
	# show the 100% achievement end scene
	else:
		complete_scene.show()
	
	show()
	

func _on_sleep_again():
	emit_signal("sleep_again")
	hide()
