extends Sprite2D
var rng = RandomNumberGenerator.new()
var precision = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	get_parent().get_node("Timer").wait_time=get_parent().speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().equiped:
		if Input.is_action_pressed("rClick"):
			for i in get_tree().root.get_child(0).get_node("ProjectilePool").get_children():
				if i.is_in_group("RevolverBullet"):
					if !i.active:
						var x = rng.randi_range(-precision,precision)
						var y = rng.randi_range(-precision,precision)
						if get_parent().get_node("Timer").time_left==0:
							get_parent().get_node("Timer").start()
							i.activate(get_global_mouse_position()+Vector2(x,y))
						break
