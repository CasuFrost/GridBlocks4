class_name searchPlayer
extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func do(start):
	return recSearch(start)
func recSearch(node):
	for i in node.get_children():
		if i.is_in_group("player"):
			print(i.name)
			return i
		else:
			recSearch(i)
