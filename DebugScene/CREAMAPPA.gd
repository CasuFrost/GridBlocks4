extends Node2D
@onready var tm =get_parent().get_node("TileMap")
@onready var player =get_parent().get_node("PlayerTest")
var my_csharp_script = load("res://DebugScene/create_world_test.cs")
var my_csharp_node = my_csharp_script.new()
var arr 
var k = []
var onRangeBlockMatrix = []
var jj = []
var cnt = 0
var raggioInBlocchi = 20
var raggio = 15
var blocchiNelRaggio = 0
var ULeft = 0
var URight = 0
var DLeft = 0
var DRight = 0
var rng = RandomNumberGenerator.new()
var loadedTile=[]
# Called when the node enters the scene tree for the first time.
func _ready():
		
		#get_parent().get_node("PlayerTest").camEn=false

				
		for i in 100: #y
			for j in 100: #x
				if !rng.randi_range(0,5)==1:
					tm.set_cell(0,tm.local_to_map(Vector2i(j*16,i*16)),7,Vector2i(0,0))
				else:
					tm.set_cell(0,tm.local_to_map(Vector2i(j*16,i*16)),10,Vector2i(0,0))
				k.append(tm.local_to_map(Vector2(j*16,i*16)))
#		for i in 7200:
#			if tm.get_cell_tile_data(0,k[0]):
#					tm.set_cells_terrain_connect(0,[k[0]],0,tm.get_cell_tile_data(0,k[0]).terrain)
#					k.pop_at(0)
	#arr = k.slice(5001, k.size())
		#tm.set_cells_terrain_path(0,k,0,tm.get_cell_tile_data(0,k[0]).terrain)
		#tm.set_cells_terrain_connect(0,jj,0,tm.get_cell_tile_data(0,jj[0]).terrain)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if false:
		for i in range(int(ULeft.x),int(URight.x)):
			for j in range(int(ULeft.y),int(DLeft.y)):
				print(i,j)
				#tm.set_cells_terrain_connect(0,[tm.local_to_map(Vector2(j*16,i*16))],0,8)
	get_parent().get_node("Sprite2D").global_position=URight
	get_parent().get_node("Sprite2D2").global_position=DRight
	get_parent().get_node("Sprite2D3").global_position=ULeft
	get_parent().get_node("Sprite2D4").global_position=DLeft
	#raggioInBlocchi = (raggio)/16
	calculateCorners()
	if (player.velocity.x!=0 or player.velocity.y!=0)and false:
		onRangeBlockMatrix.clear()
		calculateCorners()
		for i in ULeft.distance_to(URight):
			for j in ULeft.distance_to(DLeft):
				var localPos = Vector2(i*16,j*16)
				var tmp=tm.local_to_map(localPos+player.global_position-Vector2(270,100))
				#get_parent().get_node("Sprite2D5").global_position=localPos+player.global_position
				if tm.get_cell_tile_data(0,tmp):
					if tmp not in loadedTile :
						loadedTile.append(tmp)
						#tm.set_cells_terrain_connect(0,[tmp],0,tm.get_cell_tile_data(0,tmp).terrain)
						#tm.set_cells_terrain_connect(0,[tmp],0,8)
				#onRangeBlockMatrix.append(localPos+player.global_position-Vector2(250,150))
#		for i in onRangeBlockMatrix:
#			if tm.get_cell_tile_data(0,tm.local_to_map(i)):
#				tm.set_cells_terrain_connect(0,[tm.local_to_map(i)],0,tm.get_cell_tile_data(0,tm.local_to_map(i)).terrain)
#	if len(k)>1:
#		loadWorld()
	

func loadWorld():
	for i in 3:
		if tm.get_cell_tile_data(0,k[0]):
			tm.set_cells_terrain_connect(0,[k[0]],0,tm.get_cell_tile_data(0,k[0]).terrain)
			k.pop_at(0)

func calculateCorners():
	raggio = 100
	URight=player.global_position+Vector2(raggio,-raggio*0.5)
	ULeft = player.global_position+Vector2(-raggio,-raggio*0.5)
	DRight = player.global_position+Vector2(raggio,raggio*0.5)
	DLeft = player.global_position+Vector2(-raggio,raggio*0.5)

