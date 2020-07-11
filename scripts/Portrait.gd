extends Control

onready var portraits = [
	$CalmPortrait,
	$JuicedPortrait,
	$RiledPortrait,
	$BuckWildPortrait,
	$BonkersPortrait,
	$WilinPortrait
]


onready var current_portrait = 0

func _ready():
	for portrait in portraits:
		portrait.visible = false
	set_portrait(0)

func set_portrait(new_portrait_index):
	portraits[current_portrait].visible = false
	current_portrait = clamp(new_portrait_index, 0, len(portraits)-1)
	portraits[current_portrait].visible = true
