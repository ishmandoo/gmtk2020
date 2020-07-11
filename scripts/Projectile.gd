extends Area2D

onready var sprite = $ProjectileSprite
onready var player = get_node("/root/Main/Player")

onready var splat = $SplatSound
onready var stab = $StabSound
onready var bomb = $BombSound


onready var rotational_speed = 10.0
onready var speed = 500.0
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
	if not body.is_in_group("player"):
		die()
		return
	if type == Type.APPLE:
		change_player_wilin_health(1,10)
		splat.play()
		hit()
	if type == Type.WATERMELON:
		change_player_wilin_health(2,15)
		splat.play()
		hit()
	if type == Type.BANANA:
		change_player_wilin_health(0,5)
		splat.play()
		hit()
	if type == Type.SHURIKEN:
		change_player_wilin_health(0,-10)
		stab.play()
		stick()
	if type == Type.BOMB:
		change_player_wilin_health(0,-20)
		bomb.play()
		hit()
	
func die():
	queue_free()
		
