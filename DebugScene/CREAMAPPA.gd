extends Node2D

var my_csharp_script = load("res://DebugScene/create_world_test.cs")
var my_csharp_node = my_csharp_script.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	if !my_csharp_node.can:
		for i in 500:
			for j in 200:
				var t = get_parent().get_node("TileMap").local_to_map(Vector2(i*8,j*8))
				get_parent().get_node("TileMap").set_cells_terrain_connect(0,[t],0,5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




