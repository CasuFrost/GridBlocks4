extends Node2D
@onready var tileMap : TileMap = get_node("TileMap")
@onready var plyer = get_node("PlayerTest")
var constructedArray = []

var x = 2500
var y = 700
var rng = RandomNumberGenerator.new()

func _ready():
	var dir : DirAccess = DirAccess.open("user://")
	dir.remove("tilemap.txt")
	var found=false
	var a = FileAccess.open("user://tilemap.txt", FileAccess.READ)
	if a:
		if a.get_length()>0:
			found=true
			var array = JSON.parse_string(a.get_line())
			for i in len(array)-1:
				for j in len(array[0])-1:
					var x = int(array[i][j][1].split(",")[0].replace("(",""))
					var y = int(array[i][j][1].split(",")[1].replace(")",""))
					array[i][j][1]=Vector2i(x,y)
			placeTiles(array)
			return 0
	#plyer.camEn=false
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
	
func placeTiles(constructedArray):
	for i in len(constructedArray)-1:
		for j in len(constructedArray[0])-1:
			if constructedArray[i][j][0]!=-1:
				var tmpNeighboor = [0,0,0,0]
				if constructedArray[i-1][j][0]!=-1:
					tmpNeighboor[0]=1
				if constructedArray[i][j-1][0]!=-1:
					tmpNeighboor[1]=1
				if constructedArray[i][j+1][0]!=-1:
					tmpNeighboor[2]=1
				if constructedArray[i+1][j][0]!=-1:
					tmpNeighboor[3]=1
				constructedArray[i][j][1]=arrayToVector2(tmpNeighboor)
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
	var save_game = FileAccess.open("user://tilemap.txt", FileAccess.WRITE)
	save_game.store_line(JSON.stringify(a))
func placeBlockLogic(tmp,i,j,x,y,constructedArray,lastLayer):
	var localHeight = y*0.1
	if j<=y*0.03:
		tmp.append([-1,Vector2i(0,0)])
	else:
		if j<=y*0.15:
			var r = rng.randi_range(0, 6)
			if r!=1:
				tmp.append([7,0])
			else:
				tmp.append([10,0])
		else:
			if j<=y*0.25:
				var r = rng.randi_range(0, 1)
				if r==1:
					tmp.append([7,0])
				else:
					tmp.append([10,0])
			else:
				if j<=y*0.6:
					var r = rng.randi_range(0, 25)
					if r<=6:
						tmp.append([7,0])
					else:
						if r==5:
							tmp.append([11,0])
						else:
							tmp.append([10,0])
				else:
					var r = rng.randi_range(0, 10)
					if r==5:
						tmp.append([11,0])
					else:
						tmp.append([10,0])
