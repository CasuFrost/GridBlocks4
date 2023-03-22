extends Node

var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func layer1Logic(tmp):
	tmp.append([-1,Vector2i(0,0)])
func layer2Logic(tmp):
	var r = rng.randi_range(0,10)
	if r < 3:
		tmp.append([10,0])
	else:
		tmp.append([7,0])
func layer3Logic(tmp):
	var r = rng.randi_range(0,40)
	if r==15:
		tmp.append([11,0])
		return 0
	if r > 12:
		tmp.append([10,0])
	else:
		tmp.append([7,0])
func layer4Logic(tmp):
	var r = rng.randi_range(0,30)
	if r == 3 or r==4:
		tmp.append([11,0])
	else:
		tmp.append([10,0])
	
func layer5Logic(tmp):
	var r = rng.randi_range(0,4)
	if r == 3:
		tmp.append([10,0])
	else:
		tmp.append([11,0])
func layer6Logic(tmp):
	var r = rng.randi_range(0,1)
	if r != 1:
		tmp.append([13,0])
	else:
		var r2 = rng.randi_range(0,30)
		if r2 == 3 or r2==4:
			tmp.append([11,0])
		else:
			tmp.append([10,0])
