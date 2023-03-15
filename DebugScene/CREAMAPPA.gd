extends Node2D

var my_csharp_script = load("res://DebugScene/create_world_test.cs")
var my_csharp_node = my_csharp_script.new()
var arr 
# Called when the node enters the scene tree for the first time.
func _ready():
	#get_parent().get_node("PlayerTest").camEn=false
	var k = []
	if !my_csharp_node.can:
		for i in 500:
			for j in 500:
				k.append(get_parent().get_node("TileMap").local_to_map(Vector2(j*16,i*16)))
	get_parent().get_node("TileMap").set_cells_terrain_connect(0,k.slice(0, 5000),0,5)
	arr = k.slice(5001, k.size())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(Engine.get_frames_per_second())
	get_parent().get_node("TileMap").set_cells_terrain_connect(0,arr.slice(0, 8),0,5)
	arr.pop_at(0)
	arr.pop_at(0)
	arr.pop_at(0)
	arr.pop_at(0)
	arr.pop_at(0)
	arr.pop_at(0)
	arr.pop_at(0)
	arr.pop_at(0)
	
	
	




