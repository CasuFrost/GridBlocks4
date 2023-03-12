extends RigidBody2D
@export var object : tool = load("res://ToolsRes/gem_swords.tscn").instantiate()
var intensity = 0
var ob = 5
func _ready():
	if !object:
		object = load("res://ToolsRes/gem_swords.tscn").instantiate()
	intensity=$Sprite2D.material.get_shader_parameter("intensity")

func _process(delta):
	$Sprite2D.texture=object.InventaryIcon
	$Sprite2D.material.set_shader_parameter("intensity",intensity)
	if intensity<9:
		ob = 97
	if intensity>95:
		ob=5
	intensity=lerpf(intensity,ob,0.2)


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.inventory.collectObject(object)
		queue_free()
