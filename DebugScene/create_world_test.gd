extends Node2D
@onready var tileMap = get_node("TileMap")
var x = 1
var y = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	TileMap
	for i in y:
		for j in x:
			var tile = tileMap.local_to_map(Vector2(j*8,i*8))
			tileMap.set_cells_terrain_connect(0,[tile],0,5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
