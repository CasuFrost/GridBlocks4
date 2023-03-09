extends CharacterBody2D
var rng = RandomNumberGenerator.new()
const attckSpeed = 75
const SPEED = 50
const damage = 10
const JUMP_VELOCITY = -400.0
var playerDetected=true
var rangeActivate = 190
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var playerPos
var on_right : bool = false
var distOnPlayer = 0
var rng_dir = 1
var knockback = 360
var impulse = 0

func _ready():
	rng.randomize()
func _physics_process(delta):
	playerPos =get_tree().root.get_child(0).get_node("PlayerTest").global_position
	distOnPlayer=abs(playerPos.x-global_position.x)
	playerDetected = distOnPlayer<rangeActivate

	on_right=global_position.x>playerPos.x
	if not is_on_floor():
		velocity.y += gravity * delta
	if playerDetected:
		if on_right:
			$Sprite.scale.x=1
		else:
			$Sprite.scale.x=-1
	else:
		if velocity.x<1:
			$Sprite.scale.x=1
		else:
			$Sprite.scale.x=-1
	# Handle Jump.
	if is_on_wall() and is_on_floor():
		
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = playerPos-global_position
	
	if direction and playerDetected:
		if distOnPlayer>20:
			$Sprite/DownAnimationManager.play("attacckingWalk")
			velocity.x = direction.normalized().x * attckSpeed + impulse
		else:
			velocity.x = 0 + impulse
		$Sprite/UpAnimationManager.play("attacckingWalk")
	else:
		$Sprite/DownAnimationManager.play("walk")
		$Sprite/UpAnimationManager.play("walk")
		velocity.x = rng_dir*SPEED + impulse
		
	
	
		
	move_and_slide()

func KnockBack(dir):
	$KnockBack.start()
	impulse = knockback*dir

func _on_timer_timeout():
	rng_dir = rng.randi_range(-1,1)
	while(rng_dir==0):
		rng_dir = rng.randi_range(-1,1)
	#print(rng_dir)
	


func _on_knock_back_timeout():
	impulse=0


func _on_area_2d_area_entered(area):
	pass
#	if area.is_in_group("projectile"):
#		queue_free()
