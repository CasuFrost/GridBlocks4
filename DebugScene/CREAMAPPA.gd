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
var searchAlgorithmArray = []
var cestino = []
var posToDraw
var pivot = Vector2()
var direction = true
var researchDir = 1
var lastXR
var lastXL
var pivotCanMove=false
var resetJump = true
var startMove=true
var pivot2 = Vector2()
# Called when the node enters the scene tree for the first time.
func _ready():
	pivot=player.global_position
	var lastXR=player.global_position.x+200
	var lastXL=player.global_position.x-200
	#player.camEn=false
	for i in 200: #y
		for j in 200: #x
			if i>10:
				if !rng.randi_range(0,5)==1:
					loadedTile.append(Vector2i(j*16,i*16))
					tm.set_cell(0,tm.local_to_map(Vector2i(j*16,i*16)),7,Vector2i(0,0))
				else:
					loadedTile.append(Vector2i(j*16,i*16))
					tm.set_cell(0,tm.local_to_map(Vector2i(j*16,i*16)),10,Vector2i(0,0))
				k.append(tm.local_to_map(Vector2(j*16,i*16)))
				
	loadTerrain(20,20,player.global_position)
	for local in onRangeBlockMatrix:
		tm.set_cells_terrain_connect(0,[local],0,tm.get_cell_tile_data(0,local).terrain)
	onRangeBlockMatrix.clear()
#	loadTerrain(30,30,last)
#	loadTerrain(30,30,first)
func _process(delta):
	if tm.get_cell_tile_data(0,loadedTile[0]) :
		tm.set_cells_terrain_connect(0,[loadedTile[0]],0,tm.get_cell_tile_data(0,loadedTile[0]).terrain)
	loadedTile.pop_at(0)
	if pivotCanMove:
		pivot.y+=112
		pivot2.y+=112
		for i in [pivot,pivot2]:
			var local = tm.local_to_map(i)
			var local2 = tm.local_to_map(i-Vector2(0,16))
			var local3 = tm.local_to_map(i-Vector2(0,32))
			var local4 = tm.local_to_map(i-Vector2(0,48))
			var local5 = tm.local_to_map(i-Vector2(0,64))
			var local6 = tm.local_to_map(i-Vector2(0,80))
			var local7 = tm.local_to_map(i-Vector2(0,96))
			if tm.get_cell_tile_data(0,local) and (local not in searchAlgorithmArray or local not in cestino):
				searchAlgorithmArray.append(local)
			if tm.get_cell_tile_data(0,local2) and (local2 not in searchAlgorithmArray or local2 not in cestino):
				searchAlgorithmArray.append(local2)
			if tm.get_cell_tile_data(0,local3) and (local3 not in searchAlgorithmArray or local3 not in cestino):
				searchAlgorithmArray.append(local3)
			if tm.get_cell_tile_data(0,local4) and (local4 not in searchAlgorithmArray or local4 not in cestino):
				searchAlgorithmArray.append(local4)
			if tm.get_cell_tile_data(0,local5) and (local5 not in searchAlgorithmArray or local5 not in cestino):
				searchAlgorithmArray.append(local5)
			if tm.get_cell_tile_data(0,local6) and (local6 not in searchAlgorithmArray or local6 not in cestino):
				searchAlgorithmArray.append(local6)
			if tm.get_cell_tile_data(0,local7) and (local7 not in searchAlgorithmArray or local7 not in cestino):
				searchAlgorithmArray.append(local7)
				
	for i in 6:
		if searchAlgorithmArray.size()>1:
			TileMap
			#if  tm.get_cell_tile_data(0,searchAlgorithmArray[0]):
			tm.set_cells_terrain_connect(0,[searchAlgorithmArray[0]],0,tm.get_cell_tile_data(0,searchAlgorithmArray[0]).terrain)
			cestino.append(searchAlgorithmArray.pop_at(0))
	get_parent().get_node("Sprite2D").global_position=pivot
	get_parent().get_node("Sprite2D2").global_position=pivot2
	ricercaRicorsivaQuadrata(300,player.velocity.x,player.global_position)
	get_parent().get_node("Label").set_text(str(searchAlgorithmArray.size()))

func ricercaRicorsivaQuadrata(h,dir,startPos):
	if (dir>0 and direction):
		direction=false
		researchDir=1
		if false:
			pivot=Vector2(lastXR,player.global_position.y-h)
		else:
			pivot=player.global_position+Vector2(1*researchDir,-h*1.5)
		pivotCanMove=true
	if (direction==false and dir<0) or startMove:
		startMove=false
		direction=true
		researchDir=-1
		if false:
			pivot=Vector2(lastXL,player.global_position.y-h)
		else:
			pivot=player.global_position+Vector2(1*researchDir,-h*1.5)
		pivotCanMove=true
		
	if pivot.y>=player.global_position.y+h*0.2+40:
		pivot.y=player.global_position.y-h*1.2-5
		pivot.x+=16*researchDir
		pivot2.y=player.global_position.y-h*1.2-5
		pivot2.x+=16*-(researchDir)
	if abs(pivot.x-(player.global_position.x))>250:
		pivot.x=player.global_position.x
		pivot2.x=player.global_position.x
		
		
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

