#@tool
@icon("res://editor/icons/toolIcon.png")

class_name tool
extends Node2D
var scaleValue 
@export var speed : float = 0.8
@export var KnockBack : int = 150
@export var editedScale : Vector2 
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
@export var DamageAreaScaling : Vector2 = Vector2.ONE
@export var Damage : int = 10

var SpriteOffsetSetting : Vector2
@onready var inventory=get_parent().get_parent()
@onready var player = get_parent().get_parent().get_parent()
@onready var playerToolMarkerRotation = get_parent().get_parent().get_parent().get_node("Sprites/Up/FrontArm/NewPiskel-3png/ToolPosition").rotation
var equiped : bool 
@onready  var centeredInventory=get_parent().get_parent().get_node("CanvasLayer/start")
@export var type : String
func _ready():
	pass
	scaleValue = $Sprite2D.scale.x
func _draw():
	pass
func _process(delta):
	if !equiped:
		hide()
	else:
		if Input.is_action_pressed("rClick"):
			pass

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
		
func areaLenght():
	return Vector2(icon.get_width()*0.1,icon.get_height()*0.3)#*$Sprite2D.scale.y
	
	
func invIndexToPos():
	var pos = get_parent().get_parent().get_node("CanvasLayer/centerInventory/"+str(inventoryIndex)).global_position+iconOffset
	pos.y+=28
	pos.x-=5
	return pos
