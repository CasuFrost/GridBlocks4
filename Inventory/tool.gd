@tool
@icon("res://editor/icons/toolIcon.png")

class_name tool
extends Node2D
var scaleValue 
@export var pickAxepower : int
@export var rotationTool : float =51
@export  var icon : Texture2D
@export  var objectId : int
@export  var rarity : String
@export var inventoryIndex : int
@export var ToolSprite : Sprite2D 
@export var iconOffset : Vector2
@export var SpriteOffsetM : Vector2
@export var SpriteOffsetL : Vector2
var SpriteOffsetSetting : Vector2
@onready var inventory=get_parent().get_parent()
@onready var player = get_parent().get_parent().get_parent()
var equiped : bool 
@onready  var centeredInventory=get_parent().get_parent().get_node("CanvasLayer/start")
@export var type : String
func _ready():
	#SpriteOffsetSetting=SpriteOffset
	scaleValue = $Sprite2D.scale.x
	#sborra
func _draw():
	pass
func _process(delta):
	manageSpriteScale()
	
	if !equiped:
		hide()
	else:
		if Input.is_action_pressed("rClick"):
			show()
		else:
			hide()
func manageSpriteScale():
	global_position=player.toolPosition+SpriteOffsetSetting
	rotation=player.rotation
	if player.get_node("Sprites/Up").scale.x>0:
		$Sprite2D.scale.x=scaleValue
	else:
		$Sprite2D.scale.x=-scaleValue
	if $Sprite2D.scale.x>0:
		$Sprite2D.rotation=rotationTool
		SpriteOffsetSetting=SpriteOffsetM
	else:
		$Sprite2D.rotation=-rotationTool
		SpriteOffsetSetting=SpriteOffsetL
func used():
	pass
	
func invIndexToPos():
	var pos = get_parent().get_parent().get_node("CanvasLayer/centerInventory/"+str(inventoryIndex)).global_position+iconOffset
	pos.y+=28
	pos.x-=5
	return pos
