extends TileMap


onready var grid_size = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(-grid_size,grid_size):
		for j in range(-grid_size,grid_size):
			self.set_cell(i,j,get_random_tile_index())
	

	
func get_random_tile_index():
	var index_candidate = floor(rand_range(0,9))
	if index_candidate == 8:
		if rand_range(0,10) > 1:
			return index_candidate-1
	return index_candidate
