extends Node2D
@onready var tm =get_parent().get_node("TileMap")
var my_csharp_script = load("res://DebugScene/create_world_test.cs")
var my_csharp_node = my_csharp_script.new()
var arr 
var k = []
var jj = []
var cnt = 0
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
		#get_parent().get_node("PlayerTest").camEn=false
	#if !my_csharp_node.can:
		for i in 700: #y
			for j in 2500: #x
				if !rng.randi_range(0,5)==1:
					tm.set_cell(0,tm.local_to_map(Vector2i(j*16,i*16)),7,Vector2i(0,0))
				else:
					tm.set_cell(0,tm.local_to_map(Vector2i(j*16,i*16)),10,Vector2i(0,0))
				k.append(tm.local_to_map(Vector2(j*16,i*16)))
		for i in 7200:
			if tm.get_cell_tile_data(0,k[0]):
					tm.set_cells_terrain_connect(0,[k[0]],0,tm.get_cell_tile_data(0,k[0]).terrain)
					k.pop_at(0)
	#arr = k.slice(5001, k.size())
		#tm.set_cells_terrain_path(0,k,0,tm.get_cell_tile_data(0,k[0]).terrain)
		#tm.set_cells_terrain_connect(0,jj,0,tm.get_cell_tile_data(0,jj[0]).terrain)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if len(k)>1:
		loadWorld()

func loadWorld():
	for i in 3:
		if tm.get_cell_tile_data(0,k[0]):
			tm.set_cells_terrain_connect(0,[k[0]],0,tm.get_cell_tile_data(0,k[0]).terrain)
			k.pop_at(0)


