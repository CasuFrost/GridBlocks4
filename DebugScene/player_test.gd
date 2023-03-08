extends CharacterBody2D
var maxTileInfoStored=150
@onready var toolMarker = get_node("Sprites/Up/FrontArm/NewPiskel-3png/ToolPosition")
@onready var toolPosition = get_node("Sprites/Up/FrontArm/NewPiskel-3png/ToolPosition").global_position
@onready var toolRotation : float = get_node("Sprites/Up/FrontArm/NewPiskel-3png/ToolPosition").rotation
@onready var tileMap = get_parent().get_node("TileMap")
@onready var up_animation = get_node("Sprites/UpAnimationManager")
@onready var down_animation = get_node("Sprites/DownAnimationManager")
var mouse  = Vector2()
var cell :Vector2
var gravity = 13
var maxDistBlocksRange = 120
var mouseOnPlayer : bool = false
var speed = 20
var maxSpeed = 100
var jump = -300
var selectedTerrain = 3
var jumps_available 
var onAir = false
@export var maxConsecutiveJumps = 1
var destrct_array = {}
var pickacxePower = 1
var testArray = []
func _input(event):
	
	if event.is_action_pressed("zoomIn"):
		$Inventory.selected+=1
		
	if event.is_action_pressed("zoomout"):
		$Inventory.selected-=1
		
		
func _ready():
	for i in 4:
		for j in 4:
			testArray.append(Vector2i(j,i))
	
	#$Sprites/UpAnimationManager.play("toolSwing")
	$dirtPickaxing.emitting=false
	jumps_available= maxConsecutiveJumps
	
func _process(delta):
	#$"Sprites/Up/Head/NewPiskel-2png".material.set_shader_parameter("base_scroll_speed",10)
	$mousePointer.global_position=get_global_mouse_position()
	$Camera2D.zoom=clamp($Camera2D.zoom,Vector2(1.5,1.5),Vector2(5,5))
	if $Inventory.getToolType()=="None":
		get_node("Sprites/Up/FrontArm/NewPiskel-3png/ToolPosition/ActiveSelectedTool").texture=null
	toolRotation=get_node("Sprites/Up/FrontArm/NewPiskel-3png/ToolPosition").rotation
	pickacxePower=$Inventory.getPickaxePower()
	toolPosition = get_node("Sprites/Up/FrontArm/NewPiskel-3png/ToolPosition").global_position
	print_information()
	
	#print(pickacxePower)
	if tileMap :
		interactWithTilemap()
func interactWithTilemap():
	if len(destrct_array)>maxTileInfoStored:
		#print(destrct_array.find_key(5))
		destrct_array.erase(destrct_array.keys()[0])
	mouse  = Vector2i(get_global_mouse_position())
	$dirtPickaxing.global_position=mouse
	if Input.is_action_pressed("lClick") and valid_distance() and !mouseOnPlayer:
		var tile = tileMap.local_to_map(get_global_mouse_position())
		if isTileValidPosition(tile) and !mouseOnPlayer:
			tileMap.set_cells_terrain_connect(0,[tile],0,selectedTerrain)
			TileMap
			#tileMap.set_cells_terrain_connect(0,[Vector2i(0,0),Vector2i(1,0),Vector2i(2,0),Vector2i(0,1),Vector2i(1,1),Vector2i(2,1),Vector2i(0,2),Vector2i(1,2),Vector2i(2,2),Vector2i(0,3),Vector2i(1,3)],0,0)
	if Input.is_action_pressed("rClick") and valid_distance() and $Inventory.isSelectedPickaxe():
		var tile = tileMap.local_to_map(get_global_mouse_position())
		if tileMap.get_cell_tile_data(0,tile):
			#get_parent().get_node("CanvasLayer/Label").set_text(str(tileMap.get_cell_source_id(0,tile)))
			$dirtPickaxing.emitting=true
			if tile not in destrct_array:
				destrct_array[tile] = tileMap.get_cell_tile_data(0,tile).get_custom_data("break")
			else:
				destrct_array[tile]-=pickacxePower
				if destrct_array[tile]<=0:
					#resetNearTiles(tile)
					tileMap.erase_cell(0,tile)
					destrct_array.erase(tile)
		else:
			$dirtPickaxing.emitting=false
	else:
		$dirtPickaxing.emitting=false
	
func isTileValidPosition(tile):
	var tiles = [Vector2i(tile.x+1,tile.y),Vector2i(tile.x-1,tile.y),Vector2i(tile.x,tile.y+1),Vector2i(tile.x,tile.y-1)]
	for i in tiles:
		if tileMap.get_cell_tile_data(0,i) and !tileMap.get_cell_tile_data(0,tile):
			return true
	return false
func _physics_process(delta):
	if Input.is_action_pressed("plus"):
		$Camera2D.zoom+=Vector2(0.1,0.1)
	if Input.is_action_pressed("minus"):
		$Camera2D.zoom-=Vector2(0.1,0.1)
	movement()
	update_animation()
	move_and_slide()
func manageSpriteDownPos():
	if $Sprites/Down.scale.x>0:
		if $Sprites/Up.scale.x>0:
			$Sprites/Down.position.x=-1.5
		else:
			$Sprites/Down.position.x=-3
	else:
		if $Sprites/Up.scale.x>0:
			$Sprites/Down.position.x=3
		else:
			$Sprites/Down.position.x=1
func update_animation():
	manageSpriteDownPos()
	if Input.is_action_pressed("rClick"):
		if get_global_mouse_position()>global_position:
			$Sprites/Up.scale.x=1
		else:
			$Sprites/Up.scale.x=-1
		$"Sprites/Up/FrontArm/NewPiskel-3png/ToolPosition/ActiveSelectedTool".show()
		if $Inventory.getToolType()=="Pickaxe" or $Inventory.getToolType()=="Sword":
			up_animation.play("toolSwing")
		if $Inventory.getToolType()=="PointingWeapon":
			$Sprites/Up/FrontArm.look_at(get_global_mouse_position())
			#$Sprites/Up/FrontArm.rotation-=75
			up_animation.play("Pointing")
	else:
		if velocity.x<0:
			$Sprites/Up.scale.x=-1
		elif velocity.x>0:
			$Sprites/Up.scale.x=1
		$"Sprites/Up/FrontArm/NewPiskel-3png/ToolPosition/ActiveSelectedTool".hide()
		$dirtPickaxing.emitting=false
	if velocity.x<0:
		$Sprites/Down.scale.x=-1
		#$Sprites/Up.scale.x=-1
		down_animJumpWalk()
		if !Input.is_action_pressed("rClick"):
			up_animation.play("Walk")
			$Sprites/GeneralAnimationManager.play("walk")
	elif velocity.x>0:
		$Sprites/Down.scale.x=1
		#$Sprites/Up.scale.x=1
		if !Input.is_action_pressed("rClick"):
			up_animation.play("Walk")
			$Sprites/GeneralAnimationManager.play("walk")
		down_animJumpWalk()
	else: 
		if is_on_floor():
			down_animation.play("Idle")
			#$Sprites/GeneralAnimationManager.play("RESET")
		else:
			down_animation.play("jump")
		if !Input.is_action_pressed("rClick"):
			up_animation.play("Idle")
			#$Sprites/GeneralAnimationManager.play("RESET")
			
func down_animJumpWalk():
	if is_on_floor():
		down_animation.play("Walk")
	else:
		down_animation.play("jump")
func movement():
	#print(velocity.y)
	velocity.x = clamp(velocity.x,-maxSpeed,maxSpeed)
	if Input.is_action_pressed("move_left"):
		
		velocity.x-=speed
	elif Input.is_action_pressed("move_right"):
		velocity.x+=speed
	else:
		velocity.x = 0
	#velocity=Velocity
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
func switchTexture(texture,editedScale):
	get_node("Sprites/Up/FrontArm/NewPiskel-3png/ToolPosition/ActiveSelectedTool").texture=null
	if editedScale!=Vector2.ZERO:
		get_node("Sprites/Up/FrontArm/NewPiskel-3png/ToolPosition/ActiveSelectedTool").scale=editedScale
	get_node("Sprites/Up/FrontArm/NewPiskel-3png/ToolPosition/ActiveSelectedTool").texture=texture
	#print(get_node("Sprites/Up/FrontArm/NewPiskel-3png/ToolPosition/ActiveSelectedTool").texture)
func print_information():
	#print(mouseOnPlayer)
	#print(get_node("Sprites/Up/FrontArm/NewPiskel-3png/ToolPosition").get_children())
	pass#print(toolRotation)
	
	#get_parent().get_node("CanvasLayer/Label").set_text(str(toolRotation))
	#print(destrct_array)
	
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
