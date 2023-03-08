extends RigidBody2D
@export var object : tool

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture=object.icon


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
