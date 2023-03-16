extends Node2D
@onready var tm =get_parent().get_node("TileMap")
@onready var player =get_parent().get_node("PlayerTest")
var my_csharp_script = load("res://DebugScene/create_world_test.cs")
var my_csharp_node = my_csharp_script.new()
var arr 
var k = []
var onRangeBlockMatrix = []
var jj = []
var cnt = 1
var raggioInBlocchi = 20
var raggio = 15
var blocchiNelRaggio = 0
var ULeft = 0
var URight = 0
var DLeft = 0
var DRight = 0
var rng = RandomNumberGenerator.new()
var loadedTile=[]
var first
var last

var posToDraw
# Called when the node enters the scene tree for the first time.
func _ready():
	player.camEn=false
	for i in 100: #y
		for j in 100: #x
			if j!=30 or i>40:
				
				if !rng.randi_range(0,5)==1:
					loadedTile.append(Vector2i(j*16,i*16))
					tm.set_cell(0,tm.local_to_map(Vector2i(j*16,i*16)),7,Vector2i(0,0))
				else:
					loadedTile.append(Vector2i(j*16,i*16))
					tm.set_cell(0,tm.local_to_map(Vector2i(j*16,i*16)),10,Vector2i(0,0))
				k.append(tm.local_to_map(Vector2(j*16,i*16)))
				
	loadTerrain(70,70,player.global_position)
	for local in onRangeBlockMatrix:
		tm.set_cells_terrain_connect(0,[local],0,tm.get_cell_tile_data(0,local).terrain)
	onRangeBlockMatrix.clear()
#	loadTerrain(30,30,last)
#	loadTerrain(30,30,first)
func _process(delta):
	if (player.velocity.x!=0 or player.velocity.y!=0):
		pass#loadTerrain(8,5)
#	if onRangeBlockMatrix.size()>0:
#		tm.set_cells_terrain_connect(0,[onRangeBlockMatrix[0]],0,tm.get_cell_tile_data(0,onRangeBlockMatrix[0]).terrain)
#		onRangeBlockMatrix.pop_at(0)
#		tm.set_cells_terrain_connect(0,[onRangeBlockMatrix[0]],0,tm.get_cell_tile_data(0,onRangeBlockMatrix[0]).terrain)
#		onRangeBlockMatrix.pop_at(0)
#		tm.set_cells_terrain_connect(0,[onRangeBlockMatrix[0]],0,tm.get_cell_tile_data(0,onRangeBlockMatrix[0]).terrain)
#		onRangeBlockMatrix.pop_at(0)
	#posToDraw=[tm.local_to_map(start+Vector2(cnt,0)),tm.local_to_map(start+Vector2(0,cnt)),tm.local_to_map(start+Vector2(-cnt,0)),tm.local_to_map(start+Vector2(0,-cnt)),tm.local_to_map(start+Vector2(-cnt,cnt)),tm.local_to_map(start+Vector2(cnt,cnt)),tm.local_to_map(start+Vector2(cnt,-cnt)),tm.local_to_map(start+Vector2(-cnt,-cnt))]
#	for local in posToDraw:
#		if tm.get_cell_tile_data(0,local):
#			tm.set_cells_terrain_connect(0,[local],0,tm.get_cell_tile_data(0,local).terrain)
#	cnt+=1
func loadTerrain(x,y,center):
	var tmpArray = []
	for i in range(center.x-x*16,center.x+x*16,16):
		for j in range(center.y-y*16,center.y+y*16,16):
			var local = tm.local_to_map(Vector2(i,j))
			if local not in onRangeBlockMatrix:
				if tm.get_cell_tile_data(0,local):
					onRangeBlockMatrix.append(local)
	first =Vector2(center.x-x*16,player.global_position.y)
	last = Vector2(center.x+x*16,player.global_position.y)
					#tm.set_cells_terrain_connect(0,[local],0,tm.get_cell_tile_data(0,local).terrain)
func loadWorld():
	for i in 3:
		if tm.get_cell_tile_data(0,k[0]):
			tm.set_cells_terrain_connect(0,[k[0]],0,tm.get_cell_tile_data(0,k[0]).terrain)
			k.pop_at(0)

func calculateCorners():
	raggio = 10
	URight=player.global_position+Vector2(raggio,-raggio*0.5)
	ULeft = player.global_position+Vector2(-raggio,-raggio*0.5)
	DRight = player.global_position+Vector2(raggio,raggio*0.5)
	DLeft = player.global_position+Vector2(-raggio,raggio*0.5)
	
func ricorsiv(start):
	start = Vector2i(start)
	var posToDraw=[tm.local_to_map(start+Vector2i(cnt,0)),tm.local_to_map(start+Vector2i(0,cnt)),tm.local_to_map(start+Vector2i(-cnt,0)),tm.local_to_map(start+Vector2i(0,-cnt)),tm.local_to_map(start+Vector2i(-cnt,cnt)),tm.local_to_map(start+Vector2i(cnt,cnt)),tm.local_to_map(start+Vector2i(cnt,-cnt)),tm.local_to_map(start+Vector2i(-cnt,-cnt))]
	for local in posToDraw:
		if local not in onRangeBlockMatrix:
			print(local)
			onRangeBlockMatrix.append(local)
			if tm.get_cell_tile_data(0,local):
				tm.set_cells_terrain_connect(0,[local],0,tm.get_cell_tile_data(0,local).terrain)
			ricorsiv(local)
#			if tm.get_cell_tile_data(0,local):
#				print("q")
#				print(local)
#				onRangeBlockMatrix.append(local)
#				ricorsiv(local)
