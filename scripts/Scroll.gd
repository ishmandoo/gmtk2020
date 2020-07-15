extends Node2D

onready var speed = 300.0

func _process(delta):
	position += speed * Vector2.LEFT * delta
