extends KinematicBody2D

onready var sprite = $PlayerSprite
onready var wilin_sound = $WilinSound
onready var off_grid_sound = $OffGridSound
onready var gui = get_node("/root/Main/CanvasLayer/GUI")
onready var grid = get_node("/root/Main/TileMap")


export (float) var base_speed = 200.0
onready var speed = base_speed

var velocity = Vector2()

var map = [
	KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9, KEY_0,
	KEY_Q, KEY_W, KEY_E, KEY_R, KEY_T, KEY_Y, KEY_U, KEY_I, KEY_O, KEY_P,
	KEY_A, KEY_S, KEY_D, KEY_F, KEY_G, KEY_H, KEY_J, KEY_K, KEY_L, KEY_SEMICOLON,
	KEY_Z, KEY_X, KEY_C, KEY_V, KEY_B, KEY_N, KEY_M, KEY_COMMA, KEY_PERIOD, KEY_SLASH
	]

	
enum WilinLevels {CALM, BOUNCY, RILED, BONKERS, BUCK_WILD, WILIN}

	
onready var health = 100
onready var wilin_level = WilinLevels.CALM

var up = 11
var down = 21
var left = 20
var right = 22

const SCRAMBLE_TIME = 100
const SCRAMBLE_SPEED = {
	WilinLevels.CALM: 0,
	WilinLevels.BOUNCY: 5,
	WilinLevels.RILED: 7,
	WilinLevels.BONKERS: 9,
	WilinLevels.BUCK_WILD: 11,
	WilinLevels.WILIN: 13,
}
onready var scramble_timer = SCRAMBLE_TIME


const CALM_DOWN_TIME = 10
onready var calm_down_timer = CALM_DOWN_TIME

onready var off_grid = false

func get_input_event_key(index):
	var new_input = InputEventKey.new()
	new_input.set_scancode(map[index])
	return new_input
	
func reset_scramble_timer():
	scramble_timer = SCRAMBLE_TIME
	
func reset_calm_down_timer():
	calm_down_timer = CALM_DOWN_TIME

func _ready():
	update_keys()
	reset_scramble_timer()
	add_to_group("player")
	reset_key("ui_up")
	reset_key("ui_down")
	reset_key("ui_left")
	reset_key("ui_right")

	
func _process(delta):
	scramble_timer -= delta * SCRAMBLE_SPEED[wilin_level]
	calm_down_timer -= delta
	if scramble_timer < 0:
		scramble()
		reset_scramble_timer()
	if calm_down_timer < 0:
		change_wilin(-1)
	sprite.speed_scale = float(wilin_level + 1)
	speed = base_speed + .25 * base_speed * float(wilin_level + 1)
	
	if health <= 0:
		get_tree().reload_current_scene()
		
	if not off_grid and (
		(abs(position.x) > (grid.grid_size * grid.cell_size.x * grid.scale.x) or 
		abs(position.y) > (grid.grid_size * grid.cell_size.y * grid.scale.y))):
		off_grid_sound.play()
		off_grid = true
		
func scramble():
	var index_to_change = randi()%4
	if (index_to_change == 0):
		up = get_random_key()
		reset_key("ui_up")
	if (index_to_change == 1):
		down = get_random_key()
		reset_key("ui_down")
	if (index_to_change == 2):
		left = get_random_key()
		reset_key("ui_left")
	if (index_to_change == 3):
		right = get_random_key()
		reset_key("ui_right")
	update_keys()
		
func get_random_key():
	var index = randi()%map.size()
	if not index in [up, down, left, right]:
		return index
	return get_random_key()
	
func change_health(health_change):
	health = clamp(health+health_change, 0, 100)
	
func change_wilin(wilin_change):
	wilin_level = clamp(wilin_level+wilin_change, 0, len(WilinLevels) - 1)
	if wilin_level == WilinLevels.WILIN:
		wilin_sound.play()
	reset_calm_down_timer()

		
func reset_key(action):
	Input.action_release(action)
	
func update_keys():
	InputMap.action_erase_events("ui_up")
	InputMap.action_erase_events("ui_down")
	InputMap.action_erase_events("ui_left")
	InputMap.action_erase_events("ui_right")
	InputMap.action_add_event("ui_up", get_input_event_key(up))
	InputMap.action_add_event("ui_down", get_input_event_key(down))
	InputMap.action_add_event("ui_left", get_input_event_key(left))
	InputMap.action_add_event("ui_right", get_input_event_key(right))
	gui.reset_keys()
	gui.set_key("Up", get_input_event_key(up).scancode)
	gui.set_key("Down", get_input_event_key(down).scancode)
	gui.set_key("Left", get_input_event_key(left).scancode)
	gui.set_key("Right", get_input_event_key(right).scancode)
				
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
	

