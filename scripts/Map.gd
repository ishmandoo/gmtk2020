extends TileMap



# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(-100,100):
		for j in range(-100,100):
			self.set_cell(i,j,get_random_tile_index())
	

	
func get_random_tile_index():
	var index_candidate = floor(rand_range(0,9))
	if index_candidate == 8:
		if rand_range(0,10) > 1:
			return index_candidate-1
	return index_candidate
