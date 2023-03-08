extends CharacterBody2D

#onready variables
@onready var toolMarker = get_node("Sprites/Up/FrontArm/NewPiskel-3png/ToolPosition")
@onready var toolPosition = get_node("Sprites/Up/FrontArm/NewPiskel-3png/ToolPosition").global_position
@onready var tileMap = get_parent().get_node("TileMap")
@onready var up_animation = get_node("Sprites/UpAnimationManager")
@onready var down_animation = get_node("Sprites/DownAnimationManager")
@onready var downSprites = get_node("Sprites/Down")
@onready var upSprites = get_node("Sprites/Up")
@onready var pickaxeParticles = get_node("dirtPickaxing")
@onready var inventory = get_node("Inventory")
@onready var camera = get_node("Camera2D")
@onready var activeSelectedTools = get_node("Sprites/Up/FrontArm/NewPiskel-3png/ToolPosition/ActiveSelectedTool")

var maxTileInfoStored=150
var cell :Vector2
const gravity = 13
var maxDistBlocksRange = 120
var mouseOnPlayer : bool = false
var speed = 20
var maxSpeed = 100
var jump = -300
var selectedTerrain = 3
var jumps_available 
var onAir = false
var destrct_array = {}
var pickacxePower = 1
var Hp = 100
var MaxHp = 100
var hearthToShow=0

@export var maxConsecutiveJumps = 1

func _input(event):
	if event.is_action_pressed("zoomIn"):
		inventory.selected+=1
		
	if event.is_action_pressed("zoomout"):
		inventory.selected-=1

func _ready():
	pickaxeParticles.emitting=false #The particles animation of blocks breaking should not emit when the game starts
	jumps_available= maxConsecutiveJumps #Setting initial jumpes available as equal as max possible consecutive jumps

func clampingValues(): #all the values that has to be clamped 
	velocity.x = clamp(velocity.x,-maxSpeed,maxSpeed)
	Hp=clamp(Hp,0,MaxHp)
	camera.zoom=clamp(camera.zoom,Vector2(1.5,1.5),Vector2(5,5))

func _process(delta):
	clampingValues() 
	hearthToShow=int(Hp/10) #this variable manage the hearth shown in the UI
	$mousePointer.global_position=get_global_mouse_position() #I have a node called mousePointer that is an area that follows mouse position
	
	if inventory.getToolType()=="None":
		activeSelectedTools.texture=null
	pickacxePower=inventory.getPickaxePower()
	print_information()
	
	
	if tileMap :
		interactWithTilemap()
		
func interactWithTilemap():
	if len(destrct_array)>maxTileInfoStored:
		destrct_array.erase(destrct_array.keys()[0]) 

	pickaxeParticles.global_position=get_global_mouse_position()
	
	if Input.is_action_pressed("lClick") and valid_distance() and !mouseOnPlayer:
		var tile = tileMap.local_to_map(get_global_mouse_position())
		if isTileValidPosition(tile):
			tileMap.set_cells_terrain_connect(0,[tile],0,selectedTerrain)
			
	if Input.is_action_pressed("rClick") and valid_distance() and inventory.isSelectedPickaxe():
		var tile = tileMap.local_to_map(get_global_mouse_position())
		if tileMap.get_cell_tile_data(0,tile):
			pickaxeParticles.emitting=true
			if tile not in destrct_array:
				destrct_array[tile] = tileMap.get_cell_tile_data(0,tile).get_custom_data("break")
			else:
				destrct_array[tile]-=pickacxePower
				if destrct_array[tile]<=0:
					tileMap.erase_cell(0,tile)
					destrct_array.erase(tile)
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
	if Input.is_action_pressed("plus"):
		camera.zoom+=Vector2(0.1,0.1)
	if Input.is_action_pressed("minus"):
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
	if Input.is_action_pressed("rClick"):
		if get_global_mouse_position()>global_position:
			upSprites.scale.x=1
		else:
			upSprites.scale.x=-1
		activeSelectedTools.show()
		if inventory.getToolType()=="Pickaxe" or inventory.getToolType()=="Sword":
			up_animation.play("toolSwing")
		if inventory.getToolType()=="PointingWeapon":
			$Sprites/Up/FrontArm.look_at(get_global_mouse_position())
			
			up_animation.play("Pointing")
	else:
		if velocity.x<0:
			upSprites.scale.x=-1
		elif velocity.x>0:
			upSprites.scale.x=1
		activeSelectedTools.hide()
		pickaxeParticles.emitting=false
		
	if velocity.x<0:
		downSprites.scale.x=-1
		down_animJumpWalk()
		if !Input.is_action_pressed("rClick"):
			up_animation.play("Walk")
			$Sprites/GeneralAnimationManager.play("walk")
	elif velocity.x>0:
		downSprites.scale.x=1
		
		if !Input.is_action_pressed("rClick"):
			up_animation.play("Walk")
			$Sprites/GeneralAnimationManager.play("walk")
		down_animJumpWalk()
	else: 
		if is_on_floor():
			down_animation.play("Idle")
			$Sprites/GeneralAnimationManager.play("RESET")
		else:
			down_animation.play("jump")
		if !Input.is_action_pressed("rClick"):
			up_animation.play("Idle")
			$Sprites/GeneralAnimationManager.play("RESET")
			
func down_animJumpWalk():
	if is_on_floor():
		down_animation.play("Walk")
	else:
		down_animation.play("jump")
		
func movement():
	if Input.is_action_pressed("move_left"):
		velocity.x-=speed
	elif Input.is_action_pressed("move_right"):
		velocity.x+=speed
	else:
		velocity.x = 0
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
	activeSelectedTools.texture=texture
	
func print_information():
	pass
	
func valid_distance():
	if get_global_mouse_position().distance_to(global_position)<maxDistBlocksRange:
		return true
	else:
		return false

func _on_blocko_forbidden_place_area_entered(area):
	if area.is_in_group("mouse"):
		mouseOnPlayer=true

func _on_blocko_forbidden_place_area_exited(area):
	if area.is_in_group("mouse"):
		mouseOnPlayer=false
		
func resetNearTiles(tile):
	var tmpArr = [tile+Vector2i(0,1),tile+Vector2i(1,0),tile-Vector2i(0,1),tile-Vector2i(1,0)]
	for singleTile in tmpArr:
		if tileMap.get_cell_tile_data(0,singleTile):
			tileMap.set_cells_terrain_connect(0,[singleTile],0,selectedTerrain)


func _on_player_area_area_entered(area):
	if area.is_in_group("damage"):
		Hp-=area.get_parent().damage
		inventory.reset_heart(hearthToShow)

func _on_regen_timer_timeout():
	Hp+=5
	inventory.reset_heart(hearthToShow)
