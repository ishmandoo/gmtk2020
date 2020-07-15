extends Node2D

onready var start = false
onready var scroll = $ScrollNode

func _input(event):
	if event is InputEventKey and event.pressed:
		if not start:
			$WilinSound.play()
			start = true
		scroll.speed = 7500.0
		
func _process(delta):
	if scroll and scroll.position.x <= -11000 and not $WilinSound.playing:
		start()
		
func start():
	get_tree().change_scene("res://scenes/Main.tscn")

