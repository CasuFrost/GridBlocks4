extends Node2D
var maxPoints : int =15
@export var active = false
@export var knockBack : int = 70
var damage : int = 20
var speed = 20
var followPos : Vector2 = Vector2(500,500)
func _ready():
	pass#print(active) # Replace with function body.
func _process(delta):
	pass
#	if Input.is_action_just_pressed("rClick"):
#		print("a")
#		activate(get_global_mouse_position())
func _physics_process(delta):
	if active:
		$Line2D.global_position=Vector2(0,5)
		$Sprite2D.global_position+=(followPos-$Sprite2D.global_position).normalized()*speed
		
		$Line2D.add_point($Sprite2D.global_position)
		if len($Line2D.points)>maxPoints:
			$Line2D.remove_point(0)
			
		if $Sprite2D.global_position.distance_to(followPos) < 100:
			speed=7
			$AnimationPlayer.play("deActive")
		else:
			speed=20
	else:
		$Sprite2D.hide()
		$Line2D.clear_points()
		$Sprite2D/Area2D/CollisionShape2D.disabled=true
func activate(pos):
	#print(pos)
	if !active:
		$AnimationPlayer.play("born")
		$Line2D.clear_points()
		$Sprite2D.global_position=get_tree().root.get_child(0).get_node("PlayerTest").toolPosition.global_position
		$Sprite2D.show()
		speed=30
		modulate.a=160
		
		$Sprite2D/Area2D/CollisionShape2D.disabled=false
		active=true
		followPos=pos
		$Sprite2D.look_at(followPos)



func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		body.applyKnockBack(knockBack,$Sprite2D/Area2D.global_position.x)
		body.applyDamage(damage)
