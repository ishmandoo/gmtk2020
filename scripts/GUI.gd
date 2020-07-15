extends Node

onready var portrait = get_node("Portrait")
onready var health_bar = get_node("HealthBar")
onready var keyboards = [$KeyboardUp, $KeyboardDown, $KeyboardLeft, $KeyboardRight]

onready var score = $Score
onready var time = 0.0

func _ready():
	reset_keys()
	
func _process(delta):
	time += delta * 7
	score.bbcode_text = "[right]%s dog seconds[/right]" % str(stepify(time, 1))

	
func reset_keys():
	for keyboard in keyboards:
		for key in keyboard.get_children():
			key.visible = false
		
func set_key(dir, id):
	get_node("Keyboard%s/%s"%[dir, id]).visible = true

func set_wilin(new_wilin):
	portrait.set_portrait(new_wilin)

func set_health(new_health):
	health_bar.value = new_health
