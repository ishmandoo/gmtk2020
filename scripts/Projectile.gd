extends Area2D

onready var sprite = $ProjectileSprite
onready var player = get_node("/root/Main/Player")

onready var splat = $SplatSound
onready var stab = $StabSound
onready var bomb = $BombSound

onready var enabled = true

onready var rotational_speed = 10.0
onready var speed = rand_range(400,800)
onready var throw_direction = Vector2()

const Type = {
	APPLE = "apple",
	WATERMELON = "watermelon",
	BANANA = "banana",
	SHURIKEN = "shuriken",
	BOMB = "bomb"
}

onready var types = [
	Type.APPLE, 
	Type.BANANA, 
	Type.WATERMELON, 
	Type.SHURIKEN,
	Type.SHURIKEN,
	Type.SHURIKEN,
	Type.SHURIKEN,
	Type.BOMB,
	Type.BOMB,
	Type.BOMB,
	Type.BOMB
	]

const State = {
	NORMAL = "normal",
	HIT = "hit"
}

export var type = Type.WATERMELON
export var state = State.NORMAL


func get_random_type():
	return types[randi()%len(types)]

func _ready():
	type = get_random_type()
	sprite.animation = "%s_%s" % [type, state]
	connect("body_entered", self, "hit_player")

func _process(delta):
	sprite.animation = "%s_%s" % [type, state]
	sprite.rotation += rotational_speed * delta
	position += throw_direction * speed * delta

func change_player_wilin_health(wilin_change, health_change):
	player.change_wilin(wilin_change)
	player.change_health(health_change)
	
func hit():
	speed = 0.0
	rotational_speed = 0.0
	state = State.HIT
	sprite.connect("animation_finished", self, "die")
	
func stick():
	stab.connect("finished", self, "die")
	speed = 0.0
	rotational_speed = 0.0
	#player.add_child(self)

func hit_player(body):
	if not enabled:
		return
	enabled = false
	var wilin_change = 0
	var health_change = 0
	if type == Type.APPLE:
		wilin_change = 1
		health_change = 10
		splat.play()
		hit()
	if type == Type.WATERMELON:
		wilin_change = 1
		health_change = 15
		splat.play()
		hit()
	if type == Type.BANANA:
		wilin_change = 1
		health_change = 5
		splat.play()
		hit()
	if type == Type.SHURIKEN:
		health_change = -10
		stab.play()
		stick()
	if type == Type.BOMB:
		health_change = -20
		bomb.play()
		hit()
	if body.is_in_group("player"):
		change_player_wilin_health(wilin_change,health_change)
		
func die():
	queue_free()
		
