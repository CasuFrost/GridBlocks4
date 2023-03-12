extends Node2D
var knockBack = 5
var damage = 50
var active = false
var speed = 0
var shootingSpeed=15
var followPos
var cnt = 0
var dir = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !active:
		hide()
		$Area2D/CollisionShape2D.disabled=true
		
func _physics_process(delta):
	if cnt >120:
		cnt=0
		active=false
	
	if active:
		cnt+=1
		global_position+=dir.normalized()*shootingSpeed
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		body.applyKnockBack(knockBack,$Area2D.global_position.x)
		body.applyDamage(damage)
	active=false
func activate(pos):
	if !active:
		global_position=get_tree().root.get_child(0).get_node("PlayerTest").toolPosition.global_position
		show()
		speed = shootingSpeed
		$Area2D/CollisionShape2D.disabled=false
		followPos=pos
		dir = global_position.direction_to(pos)
		look_at(pos)
		active=true
