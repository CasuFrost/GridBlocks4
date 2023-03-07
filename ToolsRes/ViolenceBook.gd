extends Sprite2D
var rng = RandomNumberGenerator.new()
var precision = 55
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().equiped:
		if Input.is_action_pressed("rClick"):
			for i in get_tree().root.get_child(0).get_node("ProjectilePool").get_children():
				if i.is_in_group("Redpunch"):
					if !i.active:
						var x = rng.randi_range(-precision,precision)
						var y = rng.randi_range(-precision,precision)
						#print(i.name)
						if get_parent().get_node("Timer").time_left==0:
							get_parent().get_node("Timer").start()
							i.activate(get_global_mouse_position()+Vector2(x,y))
						break
				#break
