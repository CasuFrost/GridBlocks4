extends Control
@onready var InventoryMarker = get_node("CanvasLayer/centerInventory")
@onready var picker = get_node("CanvasLayer2/InventaryPicker")
@onready var player = get_parent()
@onready var toolName = get_node("CanvasLayer3/ToolName")
@onready var PocketObjects = get_node("PocketObjects")
@onready var NumberedObject = get_node("CanvasLayer/OpenedInventary/NumberedObject")
var selected = 2
var currentToolSelected = null
var freeSpace = [false,false,false,false,false,false,false]
var tmpSelected = null
var InventaryOpen = false
var centeredPos 
var pickerIcon = null
var mouseSelected = "0"
var mousePicked = "0"
var from="ITP"
var FoundedArray = []
func _ready():
	
	for i in $CanvasLayer/LifeBarStart.get_children():
		var n = Array(i.name.split())
		var sum=0
		for k in n :
			sum+=int(k)
		i.position.x+=40*sum
	manageSelectedInventory(selected)
	checkInvFreeSpace()
	
func setIconInv():
	for i in $Objects.get_children():
		if i.inventoryIndex<8:
			for j in InventoryMarker.get_children():
				if str(i.inventoryIndex)==j.name:
					j.get_child(0).texture=i.InventaryIcon
		else:
			for j in NumberedObject.get_children():
				if str(i.inventoryIndex)==j.name:
					j.texture=i.InventaryIcon
					FoundedArray.append(j)
	for i in InventoryMarker.get_children():
		var tmp = false
		for j in $Objects.get_children():
			if i.name==str(j.inventoryIndex):
				tmp=true	
		if !tmp:
			i.get_child(0).texture=null
			
	for i in NumberedObject.get_children():
		var tmp = false
		for j in $Objects.get_children():
			if i.name==str(j.inventoryIndex):
				tmp=true	
		if !tmp:
			i.texture=null
				
	
func checkInvFreeSpace():
	for i in $Objects.get_children():
		if i.inventoryIndex<7:
			freeSpace[i.inventoryIndex-1]=true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mousePicked=="0":
		toolName.set_text("")
	else:
		var tmpColor = ""
		match getToolFromIndex(mousePicked).rarity:
			"common":
				tmpColor="#dedede"
			"rare":
				tmpColor="#62fc72"
			"epic":
				tmpColor="#c04dfa"
		toolName.set_text("[center][color="+tmpColor+"]"+getToolFromIndex(mousePicked).objectName+"[center]")
	toolName.global_position = Vector2i(get_global_mouse_position())+Vector2i(-80,20)
	getToolOnMouse()
	managePickedObject()
	toolName.visible=InventaryOpen
	centeredPos=$CanvasLayer/centerInventory.position
	picker.global_position=get_viewport().get_mouse_position()
	picker.get_node("GPUParticles2D").emitting=InventaryOpen and mousePicked!="0"
	picker.get_node("GPUParticles2D").texture=picker.texture
	if !InventaryOpen:
		#player.textOnMouse.visible=false
		for i in $CanvasLayer/centerInventory.get_children():
			i.get_child(0).scale=Vector2(0.8,0.8)
		picker.texture=null
	else:
		pass#player.textOnMouse.visible=true
	$CanvasLayer/OpenedInventary.visible=InventaryOpen
	if Input.is_action_just_pressed("tab"):
		mouseSelected="0"
		if !InventaryOpen:
			InventaryOpen=true
			tmpSelected=selected
			selected=0
		else:
			InventaryOpen=false
			selected=tmpSelected
	if !InventaryOpen:
		selected=clamp(selected,1,7)
	changeSelected()#centInventory.global_position=get_window().size*0.5
	#print(freeSpace)
func manageSelectedInventory(i):
	for k in InventoryMarker.get_children():
		if k.name==str(i):
			k.frame=1
		else:
			k.frame=0

func changeSelected():
	setIconInv()
	if !InventaryOpen:
		if Input.is_key_pressed(KEY_1):
			selected=1
		if Input.is_key_pressed(KEY_2):
			selected=2
		if Input.is_key_pressed(KEY_3):
			selected=3
		if Input.is_key_pressed(KEY_4):
			selected=4
		if Input.is_key_pressed(KEY_5):
			selected=5
		if Input.is_key_pressed(KEY_6):
			selected=6
		if Input.is_key_pressed(KEY_7):
			selected=7
	var NothingIsSelected=true
	for i in $Objects.get_children():
		if i.inventoryIndex==selected:
			NothingIsSelected=false
			i.equiped=true
			get_parent().switchTexture(i.icon,i.editedScale)
			currentToolSelected=i
		else:
			i.equiped=false
	if NothingIsSelected:
		currentToolSelected=null
	manageSelectedInventory(selected)
func getPickaxePower():
	if currentToolSelected:
		if currentToolSelected.type=="Pickaxe":
			return currentToolSelected.pickAxepower
		else:
			return 0
	else:
		return 0
func isSelectedPickaxe():
	if currentToolSelected:
		if currentToolSelected.type=="Pickaxe":
			return true
		else:
			return false
	else:
		return false
		
func getToolType():
	if currentToolSelected:
		return currentToolSelected.type
	else:
		return "None"
func getToolSpeed():
	if currentToolSelected:
		return currentToolSelected.speed

func getToolAreaLenght():
	if currentToolSelected:
		return currentToolSelected.areaLenght()

func getToolDmgAndKnockBack():
	if currentToolSelected:
		return Vector2(currentToolSelected.Damage,currentToolSelected.KnockBack)
func getToolName():
	if currentToolSelected:
		return currentToolSelected.name
	else:
		return "None"
func reset_heart(hearthToShow):
	for i in $CanvasLayer/LifeBarStart.get_children():
		var n = Array(i.name.split())
		var sum=0
		for k in n :
			sum+=int(k)+1
			if sum>hearthToShow:
				i.hide()
			else:
				i.show()
		
func getToolOnMouse():
	if InventaryOpen:
		var founded = false
		for i in $CanvasLayer/centerInventory.get_children():
			if ((i.position)+centeredPos+Vector2(40,70)).distance_to(get_viewport().get_mouse_position())<42:
				mouseSelected=i.name
				founded=true
				i.get_child(0).scale=Vector2(1.3,1.3)
				pickerIcon=i.get_child(0).texture
			else:
				i.get_child(0).scale=Vector2(0.8,0.8)
				
		for i in NumberedObject.get_children():
			if i.position.distance_to(get_viewport().get_mouse_position())<70:
				i.scale=Vector2(3.3,3.3)
				mouseSelected=i.name
				founded=true
				pickerIcon=i.texture
			else:
				i.scale=Vector2(2.5,2.5)
		if !founded:
			mouseSelected="0"
			
	
	
func managePickedObject():
	if Input.is_action_just_released("rClick"):
			if mouseSelected!="0" and mousePicked!="0" and mousePicked!=mouseSelected:
				switchObject(mouseSelected,mousePicked)
			picker.texture=null
			mousePicked="0"
			
	if mouseSelected!="0" and pickerIcon:
		if Input.is_action_just_pressed("rClick"):
			picker.texture=pickerIcon
			mousePicked=mouseSelected
			if mousePicked.to_int()<8:
				from="ITP"
			else:
				from="PTI"
	else:
		pass

func switchObject(obj1,obj2):
	var newIndex1=null
	var newIndex2=null
	for i in $Objects.get_children():
		if i.inventoryIndex==obj1.to_int():
			newIndex1=i
		if i.inventoryIndex==obj2.to_int():
			newIndex2=i
	if newIndex1:
		newIndex1.inventoryIndex=obj2.to_int()
	if newIndex2:
		newIndex2.inventoryIndex=obj1.to_int()
	setIconInv()
	
func collectObject(object):
	#object=object.instantiate()
	for i in InventoryMarker.get_children():
		if i.get_child(0).texture==null:
			object.inventoryIndex=i.name.to_int()
			$Objects.add_child(object)
			return null
	for i in NumberedObject.get_children():
		if i.texture==null:
			object.inventoryIndex=i.name.to_int()
			$Objects.add_child(object)
			return null
			

func getToolFromIndex(index):
	for i in $Objects.get_children():
		if i.inventoryIndex==index.to_int():
			return i
