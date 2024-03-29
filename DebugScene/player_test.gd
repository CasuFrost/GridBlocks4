extends CharacterBody2D

#onready variables
@onready var toolMarker = get_node("Sprites/Up/FrontArm/NewPiskel-3png/ToolPosition")
@onready var toolPosition = get_node("Sprites/Up/FrontArm/NewPiskel-3png/ToolPosition")
@onready var tileMap = get_parent().get_node("TileMap")
@onready var up_animation = get_node("Sprites/UpAnimationManager")
@onready var down_animation = get_node("Sprites/DownAnimationManager")
@onready var damage_animation = get_node("Sprites/DamageAnimationManager")
@onready var downSprites = get_node("Sprites/Down")
@onready var upSprites = get_node("Sprites/Up")
@onready var pickaxeParticles = get_node("dirtPickaxing")
@onready var placingParticles = get_node("PlacedBlockParticle")
@onready var inventory = get_node("Inventory")
@onready var camera = get_node("Camera2D")
var start : bool = true
@onready var DamageArea = get_node("Sprites/Up/FrontArm/NewPiskel-3png/ToolPosition/ActiveSelectedTool/DamageArea2")
@onready var activeSelectedTools = get_node("Sprites/Up/FrontArm/NewPiskel-3png/ToolPosition/ActiveSelectedTool")
@onready var bloodyParticles = get_node("BloodyParticles")
var swingTooling : bool = false
var knockBackResistence : float = 1
var maxTileInfoStored=150
var canBeDamaged : bool = true
var cell :Vector2
var decelleration = 5
var MovingDecelleration = 5
var notMovingDecelleration = 2.5
const gravity = 13
var maxDistBlocksRange = 120
var mouseOnPlayer : bool = false
var speed = 10
var maxSpeed = 100
var jump = -300
var speedMultiplayer = 1
var selectedTerrain = 3
var avaliableBlockToPlace = 30

var jumps_available 
var onAir = false
var destrct_array = {}
var pickacxePower = 1
var Hp = 100
var MaxHp = 100
var hearthToShow=0
var Damage
var Knockback
var KnockbackResistence = 1

@export var maxConsecutiveJumps = 1

var tmp = Vector2(3,3)
var camEn = true

func _input(event):
	if event.is_action_pressed("zoomIn"):
		inventory.selected+=1
		
	if event.is_action_pressed("zoomout"):
		inventory.selected-=1
		
func manageDownAnimationSpeed():
	if up_animation.current_animation=="toolSwing" and inventory.getToolSpeed():
		up_animation.speed_scale=inventory.getToolSpeed()
		
	else:
		up_animation.speed_scale=1
	if down_animation.current_animation=="Walk":
		down_animation.speed_scale=abs(velocity.x)/100
	else:
		down_animation.speed_scale=1
func _ready():
	
	#createTileMap()
			
	$Camera2D.zoom=Vector2(0.7,0.7)
	#print(blockDict.new().blocDict[6].instantiate().objectName)
	saveTimeStamp()
	input_pickable=true
	pickaxeParticles.emitting=false #The particles animation of blocks breaking should not emit when the game starts
	jumps_available= maxConsecutiveJumps #Setting initial jumpes available as equal as max possible consecutive jumps
func clampingValues(): #all the values that has to be clamped 
	Hp=clamp(Hp,0,MaxHp)
	camera.zoom=clamp(camera.zoom,Vector2(3.5,3.5),Vector2(6.5,6.5))
func manageTorch():
	if inventory.getToolName()=="Torch" and Input.is_action_pressed("rClick"):
		$"Sprites/Up/FrontArm/NewPiskel-3png/ToolPosition/torch".show()
	else:
		$"Sprites/Up/FrontArm/NewPiskel-3png/ToolPosition/torch".hide()
func _process(delta):
	$Camera2D.enabled=camEn
	if start:
		$Camera2D.zoom.x=lerpf($Camera2D.zoom.x,4,0.01)
		$Camera2D.zoom.y=$Camera2D.zoom.x
		if $Camera2D.zoom.x>3.7:
			start=false
	if Hp<=0:
		dead()
	if !canBeDamaged:
		damage_animation.play("immunity")
	else:
		if damage_animation.current_animation!="damaged":
			damage_animation.play("RESET")
	canBeDamaged=$ImmunityTimer.time_left==0
	manageDownAnimationSpeed()
	manageTorch()
	clampingValues() 
	hearthToShow=int(Hp/10) #this variable manage the hearth shown in the UI
	$mousePointer.global_position=get_global_mouse_position() #I have a node called mousePointer that is an area that follows mouse position
	if inventory.getToolType()=="None" and !swingTooling:
		activeSelectedTools.texture=null
	if inventory.getToolType()=="Sword" or inventory.getToolType()=="Pickaxe":
		#DamageArea.get_child(0).shape.extents=Vector2(20,70)
		DamageArea.get_child(0).shape.extents=inventory.getToolAreaLenght()
		var data = inventory.getToolDmgAndKnockBack()
		Damage=data.x
		Knockback=data.y
	else:
		DamageArea.get_child(0).shape.extents=Vector2.ZERO
	pickacxePower=inventory.getPickaxePower()
	print_information()
	if tileMap :
		interactWithTilemap()
		
		
func interactWithTilemap():
	
	if avaliableBlockToPlace<0:
		avaliableBlockToPlace=0
	if len(destrct_array)>maxTileInfoStored:
		destrct_array.erase(destrct_array.keys()[0]) 
		

	pickaxeParticles.global_position=get_global_mouse_position()
	placingParticles.global_position=get_global_mouse_position()
	if Input.is_action_pressed("lClick") and valid_distance() and !mouseOnPlayer and !mouseOnPlayer and !Input.is_action_pressed("rClick") :
			var tile = tileMap.local_to_map(get_global_mouse_position())
			selectedTerrain=inventory.getSelectedBlocks().blockId
			if isTileValidPosition(tile) and inventory.getSelectedBlocks().availableBlocks>0 and selectedTerrain!=0:
				#tileMap.set_cells_terrain_connect(0,[tile],0,selectedTerrain)
				tileMap.set_cell(0,tile,selectedTerrain,Vector2i(0,0))
				if get_parent().constructedArray:
					get_parent().newBlock(Vector2i(get_global_mouse_position()),selectedTerrain)
				placingParticles.emitting=true
				inventory.getSelectedBlocks().availableBlocks-=1
				if inventory.getSelectedBlocks().availableBlocks==0:
					inventory.getSelectedBlocks().queue_free()
	if Input.is_action_pressed("rClick") and valid_distance() and inventory.isSelectedPickaxe() and !Input.is_action_pressed("lClick"):
		var tile = tileMap.local_to_map(get_global_mouse_position())
		if tileMap.get_cell_tile_data(0,tile):
			pickaxeParticles.emitting=true
			if tile not in destrct_array:
				destrct_array[tile] = tileMap.get_cell_tile_data(0,tile).get_custom_data("break")
			else:
				#tileMap.get_cell_tile_data(0,tile).material.set_shader_parameter("sensitivity",0.5)
				destrct_array[tile]-=inventory.getPickaxePower()
				if destrct_array[tile]<=0:
					if tileMap.get_cell_tile_data(0,tile).get_custom_data("collectable"):
						inventory.collectBlock(blockDict.new().blocDict[tileMap.get_cell_tile_data(0,tile).get_custom_data("blockId")].instantiate())
					destroyBlock(tile)
					destrct_array.erase(tile)
					resetNearBlocks(tile)
					if get_parent().constructedArray:
						get_parent().removeBlock(Vector2i(get_global_mouse_position()))
		else:
			pickaxeParticles.emitting=false
	else:
		pickaxeParticles.emitting=false

func isTileValidPosition(tile):
	var tiles = [Vector2i(tile.x+1,tile.y),Vector2i(tile.x-1,tile.y),Vector2i(tile.x,tile.y+1),Vector2i(tile.x,tile.y-1)]
	for i in tiles:
		if tileMap.get_cell_tile_data(0,i) and !tileMap.get_cell_tile_data(0,tile):
			return true
	return false
	
func zoomCameraInput():
	if Input.is_action_pressed("plus") and !start:
		camera.zoom+=Vector2(0.1,0.1)
	if Input.is_action_pressed("minus") and !start:
		camera.zoom-=Vector2(0.1,0.1)
		
func _physics_process(delta):
	zoomCameraInput()
	movement()
	update_animation()
	move_and_slide()
	
func manageSpriteDownPos():
	if downSprites.scale.x>0:
		if upSprites.scale.x>0:
			downSprites.position.x=-1.5
		else:
			downSprites.position.x=-3
	else:
		if upSprites.scale.x>0:
			downSprites.position.x=3
		else:
			downSprites.position.x=1
			
func update_animation():
	manageSpriteDownPos()
	if inventory.getToolType()=="Pickaxe" or inventory.getToolType()=="Sword":
		if swingTooling:
			if get_global_mouse_position()>global_position:
				upSprites.scale.x=1
			else:
				upSprites.scale.x=-1
		else:
			if velocity.x<0:
				upSprites.scale.x=-1
			elif velocity.x>0:
				upSprites.scale.x=1
	elif inventory.getToolType()=="PointingWeapon":
		if Input.is_action_pressed("rClick"):
			if get_global_mouse_position()>global_position:
				upSprites.scale.x=1
			else:
				upSprites.scale.x=-1
		else:
			if velocity.x<0:
				upSprites.scale.x=-1
			elif velocity.x>0:
				upSprites.scale.x=1
	elif inventory.getToolType()=="None":
			if velocity.x<0:
				upSprites.scale.x=-1
			elif velocity.x>0:
				upSprites.scale.x=1
	if Input.is_action_pressed("rClick"):
		
		activeSelectedTools.show()
		if inventory.getToolType()=="Pickaxe" or inventory.getToolType()=="Sword":
			swingTooling=true
			up_animation.play("toolSwing")
		if inventory.getToolType()=="PointingWeapon":
			$Sprites/Up/FrontArm.look_at(get_global_mouse_position())
			swingTooling=false
			up_animation.play("Pointing")
	else:
		
		if  !swingTooling:
			activeSelectedTools.hide()
		pickaxeParticles.emitting=false
		
	if velocity.x<0:
		downSprites.scale.x=-1
		down_animJumpWalk()
		if !Input.is_action_pressed("rClick") and !swingTooling:
			up_animation.play("Walk")
			$Sprites/GeneralAnimationManager.play("walk")
	elif velocity.x>0:
		downSprites.scale.x=1
		
		if !Input.is_action_pressed("rClick") and !swingTooling:
			up_animation.play("Walk")
			$Sprites/GeneralAnimationManager.play("walk")
		down_animJumpWalk()
	else: 
		if is_on_floor():
			down_animation.play("Idle")
			$Sprites/GeneralAnimationManager.play("RESET")
		else:
			down_animation.play("jump")
		if !Input.is_action_pressed("rClick") and !swingTooling:
			up_animation.play("Idle")
			$Sprites/GeneralAnimationManager.play("RESET")
			
func down_animJumpWalk():
	if is_on_floor():
		down_animation.play("Walk")
	else:
		down_animation.play("jump")
func decellerate():
	if velocity.x>0:
		velocity.x-=decelleration
	elif velocity.x<0:
		velocity.x+=decelleration
func movement():
	if Input.is_action_pressed("move_left"):
		if velocity.x>-maxSpeed*speedMultiplayer:
			velocity.x-=speed*speedMultiplayer
			decelleration=MovingDecelleration*speedMultiplayer
	elif Input.is_action_pressed("move_right"):
		if velocity.x<maxSpeed*speedMultiplayer:
			velocity.x+=speed*speedMultiplayer
			decelleration=MovingDecelleration*speedMultiplayer
	else:
		if abs(velocity.x)<5:
			decelleration=0
			velocity.x=lerpf(velocity.x,0,1)
		else:
			decelleration=notMovingDecelleration*speedMultiplayer
	decellerate()
	if !is_on_floor():
		onAir=true
		velocity.y+=gravity
	else:
		if onAir:
			$Sprites/LandJumpAnimationManager.play("landed")
			onAir=false
		jumps_available=maxConsecutiveJumps
	if  Input.is_action_just_pressed("jump") and jumps_available>0:
		down_animation.play("jump")
		jumps_available-=1
		$Sprites/LandJumpAnimationManager.play("jump")
		velocity.y=jump
		
func switchTexture(texture,editedScale): #this function give to the sprite that works as selected tool, the texture of the active selected weapon
	activeSelectedTools.texture=null
	if editedScale!=Vector2.ZERO:
		activeSelectedTools.scale=editedScale
	else:
		activeSelectedTools.scale=Vector2.ONE
	activeSelectedTools.texture=texture
	

	
func valid_distance():
	if get_global_mouse_position().distance_to(global_position)<maxDistBlocksRange:
		return true
	else:
		return false


		
func resetNearTiles(tile):
	var tmpArr = [tile+Vector2i(0,1),tile+Vector2i(1,0),tile-Vector2i(0,1),tile-Vector2i(1,0)]
	for singleTile in tmpArr:
		if tileMap.get_cell_tile_data(0,singleTile):
			tileMap.set_cells_terrain_connect(0,[singleTile],0,selectedTerrain)


func _on_player_area_area_entered(area):
	if area.is_in_group("damage") and canBeDamaged:
		$ImmunityTimer.start()
		damage_animation.play("damaged")
		applyKnockback(area.get_parent().get_parent().knockBack,area.get_parent().global_position.x)
		inventory.reset_heart(hearthToShow)

func _on_regen_timer_timeout():
	Hp+=5
	inventory.reset_heart(hearthToShow)
	
func resetNearBlocks(BrokenTile):
	var tmpArray = [BrokenTile,BrokenTile+Vector2i(0,1),BrokenTile+Vector2i(1,0),BrokenTile-Vector2i(0,1),BrokenTile-Vector2i(1,0),BrokenTile-Vector2i(1,1),BrokenTile+Vector2i(1,1)]
	for k in tmpArray:
		var data = tileMap.get_cell_tile_data(0,k)
		if data:
			tileMap.erase_cell(0,k)
			tileMap.set_cells_terrain_connect(0,[k],0,data.get_custom_data("blockId"),data.terrain)
			#tileMap.set_cells_terrain_connect(0,[k],0,data.get_custom_data("blockId"))

func _on_blocko_forbidden_place_mouse_entered():
	mouseOnPlayer=true


func _on_blocko_forbidden_place_mouse_exited():
	mouseOnPlayer=false


func applyKnockback(value,Xpos):
	var knockbackDir
	if global_position.x<Xpos:
		knockbackDir=-1
	else:
		knockbackDir=1
	velocity.x =value*knockbackDir*knockBackResistence
	velocity.y = -value*0.5*knockBackResistence



func _on_damage_animation_manager_animation_finished(anim_name):
	if anim_name=="damaged":
		damage_animation.play("RESET")

func dead():
	pass


func _on_damage_area_2_body_entered(body):
	if body.is_in_group("enemy"):
		var dir = -upSprites.scale.x*900000
		body.applyKnockBack(Knockback,dir)
		body.applyDamage(Damage)


func _on_up_animation_manager_animation_finished(anim_name):
	if anim_name=="toolSwing":
		#print("CAZZO")
		swingTooling=false
		
func print_information():
	#get_parent().get_node("CanvasLayer/Label").set_text(str(Engine.get_frames_per_second()))
	#get_parent().get_node("CanvasLayer/Label").set_text(str(DamageArea.get_child(0).shape.extents)+" "+str(DamageArea.get_child(0).scale))
	#get_parent().get_node("CanvasLayer/Label2").set_text("xVelocity : "+str(velocity.x))
	pass

func saveTimeStamp():
	var save_game = FileAccess.open("res://savegame.txt", FileAccess.WRITE)
	var unix_time: float = Time.get_unix_time_from_system()
	var datetime_dict: Dictionary = Time.get_datetime_dict_from_unix_time(unix_time)
	var system_time: String = Time.get_time_string_from_system()
	var str = str(datetime_dict["day"])+"/"+str(datetime_dict["month"])+"/"+str(datetime_dict["year"])+" ore : "+str(system_time)
	save_game.store_line(str)

func destroyBlock(Tile):
	tileMap.erase_cell(0,Tile)
	#print(blockDict.new().blocDict[tileMap.get_cell_tile_data(0,Tile).get_custom_data("blockId")])
func createTileMap():
	var worldMatrix : Array
	var worldMatrixRows : Array
	var matrixSize = 100
	for i in matrixSize:
		worldMatrixRows.append(0)
	for i in matrixSize:
		worldMatrix.append(worldMatrixRows)

	for i in matrixSize:
		for j in matrixSize:
			var tile = tileMap.local_to_map(Vector2(j*8,i*8))
			tileMap.set_cells_terrain_connect(0,[tile],0,selectedTerrain)
			if tileMap.get_cell_tile_data(0,tile):
				worldMatrix[i][j] = tileMap.get_cell_tile_data(0,tile).get_custom_data("blockId")
				#tileMap.set_cells_terrain_connect(0,[tile],0,selectedTerrain)
			else:
				worldMatrix[i][j] = null
	for i in worldMatrix:
		for j in i:
			if j!=null:
				pass
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
func sum_array(array):
	var sum = 0.0
	for element in array:
		sum+=element
	return sum
func calcNeigbhoor(tile):
	#tile = tileMap.loca
	var ne = [0,0,0,0]
	var tiles = [tile+Vector2i(0,-16),tile+Vector2i(-16,0),tile+Vector2i(16,0),tile+Vector2i(0,16)]
	pass
	#up left right down
	for i in 4 :
		print(tileMap.get_cell_tile_data(0,tiles[i]))
		if tileMap.get_cell_tile_data(0,tiles[i]):
			ne[i]=1
	print(ne)
	return ne
	
