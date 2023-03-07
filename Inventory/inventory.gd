extends Control
@onready var InventoryMarker = get_node("CanvasLayer/centerInventory")
@onready var player = get_parent()
var selected = 2
var currentToolSelected = null
var freeSpace = [false,false,false,false,false,false,false]
# Called when the node enters the scene tree for the first time.
func _ready():
	manageSelectedInventory(selected)
	checkInvFreeSpace()
func setIconInv():
	for i in $Objects.get_children():
		for j in InventoryMarker.get_children():
			if str(i.inventoryIndex)==j.name:
				j.get_child(0).texture=i.icon
				#j.get_child(0).position = i.iconOffset

func checkInvFreeSpace():
	for i in $Objects.get_children():
		freeSpace[i.inventoryIndex-1]=true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
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
	
