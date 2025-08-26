extends Area2D


signal token_collected(token_node)


@onready var audio = $AudioStreamPlayer2D

var _collected = false


func _ready() -> void:
	
	self.connect("body_entered", Callable(self, "_on_body_entered"))
	
	# to do: add token to group "tokens" for easy connection to main


func _on_body_entered(body: Node) -> void:
		
	# Only react to the player
	if body is CharacterBody2D:
		
		print("picking up a token")
		emit_signal("token_collected", self)
		# audio.play()
		
		_collected = true
		hide()
