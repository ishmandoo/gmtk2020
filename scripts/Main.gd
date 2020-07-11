extends Node

onready var Projectile = load("res://scenes/Projectile.tscn")

onready var music_layers = [
	$MusicLayer1, 
	$MusicLayer2, 
	$MusicLayer3, 
	$MusicLayer4,
	$MusicLayer5, 
	$MusicLayer6,
	$MusicLayer7, 
	$MusicLayer8
	]

onready var player = $Player
onready var gui = $CanvasLayer/GUI

onready var radius = 1000

var next_throw = 1.0


func _ready():
	pass


func random_throw():
	var throw = (Vector2.RIGHT * radius).rotated(rand_range(0,2*PI))
	
	var new_projectile = Projectile.instance()

	new_projectile.position = throw + player.position
	add_child(new_projectile)
	new_projectile.throw_direction = -throw.normalized()

func _process(delta):
	next_throw -= delta
	if next_throw < 0:
		random_throw()
		next_throw = rand_range(0,2)
		
	gui.set_wilin(player.wilin_level)
	gui.set_health(player.health)
	
	for i in range(len(music_layers)):
		if not music_layers[i].playing:
			music_layers[i].play()
		if i <= player.wilin_level:
			music_layers[i].volume_db = -25.0
		else:
			music_layers[i].volume_db = -45.0
