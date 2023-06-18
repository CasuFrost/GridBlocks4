extends Node2D
@onready var tileMap : TileMap = get_node("TileMap")
@onready var plyer = get_node("PlayerTest")
var constructedArray = []
@onready var LayerLogic = get_node("PlaceLayerLogic")
@export var x = 400
@export var y = 50
var rng = RandomNumberGenerator.new()

func _ready():
	#plyer.camEn=false
	#plyer.global_position.x = x*8
	var found=false
	var a = FileAccess.open("user://tilemap.txt", FileAccess.READ)
	if a:
		if a.get_length()>0:
			found=true
			var array = JSON.parse_string(a.get_line())
			for i in len(array)-1:
				var tmp = []
				for j in len(array[0])-1:
					var x = int(array[i][j][1].split(",")[0].replace("(",""))
					var y = int(array[i][j][1].split(",")[1].replace(")",""))
					array[i][j][1]=Vector2i(x,y)
			placeTiles(array)
			constructedArray=array
			return 0
	
	var lastLayer=[]
	if !found:
		for i in x:
			var tmp=[]
			for j in y:
				if j==0 or i == x-1 or i==0 or j==y-1:
						tmp.append([-1,Vector2i(0,0)])
				else:
					placeBlockLogic(tmp,i,j,x,y,constructedArray,lastLayer)
					
			constructedArray.append(tmp)
			lastLayer=tmp
			
		placeTiles(constructedArray)
		save(constructedArray)
		
func calcNeighboor(i,j,constructedArray):
	var tmpNeighboor = [0,0,0,0]
	if constructedArray[i-1][j][0]!=-1:
		tmpNeighboor[0]=1
	if constructedArray[i][j-1][0]!=-1:
		tmpNeighboor[1]=1
	if constructedArray[i][j+1][0]!=-1:
		tmpNeighboor[2]=1
	if constructedArray[i+1][j][0]!=-1:
		tmpNeighboor[3]=1
	return tmpNeighboor
func placeTiles(constructedArray):
	for i in len(constructedArray)-1:
		for j in len(constructedArray[0])-1:
			if constructedArray[i][j][0]!=-1:
				constructedArray[i][j][1]=arrayToVector2(calcNeighboor(i,j,constructedArray))
			tileMap.set_cell(0,Vector2(i,j),constructedArray[i][j][0],constructedArray[i][j][1])
	
func _process(delta):
	if Input.is_action_just_pressed("q"):
		var dir : DirAccess = DirAccess.open("user://")
		dir.remove("tilemap.txt")
	pass
	
func sum_array(array):
	var sum = 0.0
	for element in array:
		sum+=element
	return sum

func arrayToVector2(array):
	# array = [up,left,right,down]
	if sum_array(array)==0:
		return  Vector2i(0,0)
	if sum_array(array)==4:
		return Vector2i(2,2)
	if array==[0,0,0,1]:
		return Vector2i(1,0)
	if array==[1,0,0,1]:
		return Vector2i(2,0)
	if array==[1,0,0,0]:
		return Vector2i(3,0)
	if array==[0,0,1,0]:
		return Vector2i(0,1)
	if array==[0,1,1,0]:
		return Vector2i(0,2)
	if array==[0,1,0,0]:
		return Vector2i(0,3)
	# array = [up,left,right,down]
	if array==[0,0,1,1]:
		return Vector2i(1,1)
		
	if array==[0,1,1,1]:
		return Vector2i(1,2)
	
	if array==[0,1,0,1]:
		return Vector2i(1,3)
		
	if array==[1,0,1,1]:
		return Vector2i(2,1)
		
	if array==[1,1,0,1]:
		return Vector2i(2,3)
		
	if array==[1,0,1,0]:
		return Vector2i(3,1)
		
	if array==[1,1,1,0]:
		return Vector2i(3,2)
	if array==[1,1,0,0]:
		return Vector2i(3,3)
		
func save(a):
	var dir : DirAccess = DirAccess.open("user://")
	dir.remove("tilemap.txt")
	var save_game = FileAccess.open("user://tilemap.txt", FileAccess.WRITE)
	save_game.store_line(JSON.stringify(a))
func placeBlockLogic(tmp,i,j,x,y,constructedArray,lastLayer):
	var actualLayer = int((float(j)/y)/0.05)
	if actualLayer==1 or actualLayer==2:
		LayerLogic.layer1Logic(tmp)
	elif actualLayer==3 or actualLayer==4:
		LayerLogic.layer2Logic(tmp)
	elif actualLayer==5 or actualLayer==6:
		LayerLogic.layer3Logic(tmp)
	elif actualLayer==7 or actualLayer==8:
		LayerLogic.layer4Logic(tmp)
	elif actualLayer==9 or actualLayer==10:
		LayerLogic.layer5Logic(tmp)
	elif actualLayer==11 or actualLayer==12:
		LayerLogic.layer6Logic(tmp)
	elif actualLayer==13 or actualLayer==14:
		LayerLogic.layer3Logic(tmp)
	elif actualLayer==15 or actualLayer==16:
		LayerLogic.layer4Logic(tmp)
	elif actualLayer==17 or actualLayer==18:
		LayerLogic.layer3Logic(tmp)
	elif actualLayer==19 or actualLayer==20:
		LayerLogic.layer4Logic(tmp)
	else:
		LayerLogic.layer1Logic(tmp)
	
func calculateLayer(height):
	var layer = y*0.05
	return ((height/y)*0.05)
func newBlock(pos,tile):
	pos=pos/Vector2i(16,16)
	var tmp = [0,0,0,0]
	# array = [up,left,right,down]
	if constructedArray[pos.x+1][pos.y][0]!=-1:
		tmp[2]=1
	if constructedArray[pos.x-1][pos.y][0]!=-1:
		tmp[1]=1
	if constructedArray[pos.x][pos.y+1][0]!=-1:
		tmp[3]=1
	if constructedArray[pos.x][pos.y-1][0]!=-1:
		tmp[0]=1
	var vec = arrayToVector2(tmp)
	tileMap.set_cell(0,pos,tile,Vector2i(vec.y,vec.x))
	constructedArray[pos.x][pos.y][0]=tile
	constructedArray[pos.x][pos.y][1]=Vector2i(vec.y,vec.x)
	resetNearBlock(pos)
	#save(constructedArray)
	
func setBlock(pos,tile):
	pos=pos/Vector2i(16,16)
	tileMap.set_cell(0,pos,tile,arrayToVector2(calcNeighboor(pos.x,pos.y,constructedArray)))
	
func resetNearBlock(pos):
	var nearPositions = [pos+Vector2i(1,0),pos+Vector2i(-1,0),pos+Vector2i(0,-1),pos+Vector2i(0,1)]
	for nearTile in nearPositions:
		if tileMap.get_cell_source_id(0,nearTile)!=-1 and  nearTile.x<x-1 and nearTile.y<y-1:
			var tmp = [0,0,0,0]
			if constructedArray[nearTile.x+1][nearTile.y][0]!=-1:
				tmp[2]=1
			if constructedArray[nearTile.x-1][nearTile.y][0]!=-1:
				tmp[1]=1
			if constructedArray[nearTile.x][nearTile.y+1][0]!=-1:
				tmp[3]=1
			if constructedArray[nearTile.x][nearTile.y-1][0]!=-1:
				tmp[0]=1
			var vec = arrayToVector2(tmp)
			var sc = tileMap.get_cell_source_id(0,nearTile)
			
			constructedArray[nearTile.x][nearTile.y][0]=sc
			constructedArray[nearTile.x][nearTile.y][1]=Vector2i(vec.y,vec.x)
			tileMap.erase_cell(0,nearTile)
			tileMap.set_cell(0,nearTile,sc,Vector2i(vec.y,vec.x))
func removeBlock(pos):
	pos=pos/Vector2i(16,16)
	constructedArray[pos.x][pos.y+1][0]=-1
	#save(constructedArray)


func saveButton():
	save(constructedArray)
