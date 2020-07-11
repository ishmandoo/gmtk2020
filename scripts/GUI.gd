extends Node

onready var portrait = get_node("Portrait")
onready var health_bar = get_node("HealthBar")
onready var wilin = 0
onready var health = 100

func _ready():
	reset_keys()
	
func reset_keys():
	for key in $Keyboard.get_children():
		key.visible = false
		
func set_key(id):
	get_node("Keyboard/"+str(id)).visible = true

func set_wilin(new_wilin):
	wilin = new_wilin
	portrait.set_portrait(new_wilin)

func set_health(new_health):
	health_bar.value = new_health
