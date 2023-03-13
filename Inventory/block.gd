@icon("res://editor/icons/blockIcon.png")
class_name block
extends Node2D
@export var objectName : String = "None"
@export var availableBlocks : int = 0
@export var icon : Texture
@export var blockId : int
@export var InventoryIndex : int
@export  var rarity : String = "common"

func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
