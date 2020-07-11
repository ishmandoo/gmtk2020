extends KinematicBody2D

onready var sprite = $PlayerSprite
onready var wilin_sound = $WilinSound
onready var gui = get_node("/root/Main/CanvasLayer/GUI")


export (float) var base_speed = 200.0
onready var speed = base_speed

var velocity = Vector2()

var map = [
	[KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9, KEY_0],
	[KEY_Q, KEY_W, KEY_E, KEY_R, KEY_T, KEY_Y, KEY_U, KEY_I, KEY_O, KEY_P],
	[KEY_A, KEY_S, KEY_D, KEY_F, KEY_G, KEY_H, KEY_J, KEY_K, KEY_L, KEY_SEMICOLON],
	[KEY_Z, KEY_X, KEY_C, KEY_V, KEY_B, KEY_N, KEY_M, KEY_COMMA, KEY_PERIOD, KEY_QUESTION]
	]
	
enum WilinLevels {CALM, BOUNCY, RILED, BONKERS, BUCK_WILD, WILIN}

	
onready var health = 100
onready var wilin_level = WilinLevels.CALM

var HEIGHT = len(map)
var WIDTH = len(map[0])
var ORIGIN_MAX_Y = WIDTH-3
var ORIGIN_MAX_X = HEIGHT-2

var origin = Vector2(1, 0)
var up = Vector2(1, 1)
var down = Vector2(2, 1)
var left =  Vector2(2, 0)
var right =  Vector2(2, 2)

var KEY_MOVE_OPTIONS = [
	Vector2.UP,
	Vector2.DOWN,
	Vector2.LEFT,
	Vector2.RIGHT
]

const SCRAMBLE_TIME = 5.0
onready var timer = SCRAMBLE_TIME

func get_key(coords):
	var new_input = InputEventKey.new()
	new_input.set_scancode(map[int(coords.x)][int(coords.y)])
	return new_input
	

func _ready():
	update_keys()
	add_to_group("player")
	
func _process(delta):
	print(up, down, left, right)
	timer -= delta
	if timer < 0:
		scramble()
		reset_scramble_timer()
	sprite.speed_scale = float(wilin_level + 1)
	speed = base_speed + .25 * base_speed * float(wilin_level + 1)
	
	if health <= 0:
		get_tree().reload_current_scene()
		
	
func is_valid_origin(vec):
	return (vec.x >= 0) and (vec.x <= ORIGIN_MAX_X) and (vec.y >= 0) and (vec.y <= ORIGIN_MAX_Y)
	
func reset_scramble_timer():
	timer = SCRAMBLE_TIME
	
func random_translate():
	var choice = KEY_MOVE_OPTIONS[randi() % KEY_MOVE_OPTIONS.size()]
	var new_origin_candidate = origin + choice
	if is_valid_origin(new_origin_candidate):
		translate(choice)
	else:
		random_translate()
		
func scramble():
	var index_to_change = randi()%4
	if (index_to_change == 0):
		up = get_random_key()
	if (index_to_change == 1):
		down = get_random_key()
	if (index_to_change == 2):
		left = get_random_key()
	if (index_to_change == 3):
		right = get_random_key()
	update_keys()
		
func get_random_key():
	var x = randi()%map.size()
	var y = randi()%map[0].size()
	var key_coords = Vector2(x,y)
	if not (
		(key_coords == up) or 
		(key_coords == down) or 
		(key_coords == left) or 
		(key_coords == right)):
		return key_coords
	return get_random_key()
	
func translate(vec):
	origin += vec
	up += vec
	down += vec
	left += vec
	right += vec
	update_keys()
	
func change_health(health_change):
	health = clamp(health+health_change, 0, 100)
	
func change_wilin(wilin_change):
	wilin_level = clamp(wilin_level+wilin_change, 0, len(WilinLevels) - 1)
	if wilin_level == WilinLevels.WILIN:
		wilin_sound.play()
	
func update_keys():
	InputMap.action_erase_events("ui_up")
	InputMap.action_erase_events("ui_down")
	InputMap.action_erase_events("ui_left")
	InputMap.action_erase_events("ui_right")
	InputMap.action_add_event("ui_up", get_key(up))
	InputMap.action_add_event("ui_down", get_key(down))
	InputMap.action_add_event("ui_left", get_key(left))
	InputMap.action_add_event("ui_right", get_key(right))
	gui.reset_keys()
	for key in [up, down, left, right]:
		gui.set_key(get_key(key).scancode)
	for x in InputMap.get_actions():
		Input.action_release(x)
				
func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	if velocity == Vector2.ZERO:
		sprite.animation = "idle"
	else:
		sprite.animation = "running"
		rotation = velocity.angle()

func _physics_process(delta):
	get_input()
	move_and_slide(velocity)
	

