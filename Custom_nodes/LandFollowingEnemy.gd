@icon("res://Custom_nodes/landFollowingEnemu.png")
class_name LandFollowingEnemy
#this nodes describes all the enemies that run on the land and have to follow the player
#LIST OF NODE TO GIVE TO THIS CUSTO_NODE : 
# sprites with 4 animation manager (up, down, landJump and general)

#-UpAnimationManager
#-DownAnimationManager
#-LandJumpAnimationManager
#-GeneralAnimationManager

#collision shape
#damage area

extends CharacterBody2D

@export var hp : int = 100
@export var jump : int = -400
@export var patrollingSpeed : int 
@export var attackingSpeed : int 
@export var playerDetectRange : int = 200
@export var gravity : int
@export var MaxYSpeed : int = 1000
@export var damage : int
@export var SecToChangeDir : int = 5
@export var accelleration : int = 5
@onready var playerPos = get_tree().root.get_child(0).get_node("PlayerTest").global_position
@onready var UpAnim = get_node("UpAnimationManager")
@onready var DownAnim = get_node("DownAnimationManager")
@onready var LandJumpAnim = get_node("LandJumpAnimationManager")
@onready var GeneralAnim = get_node("GeneralAnimationManager")
@onready var Sprite = get_node("DirectionScaler")

var rng = RandomNumberGenerator.new()
var rng_dir : int = 1
var playerDir : int = 0
var timerValue = 0


func _ready():
	rng.randomize()
	set_collision_layer_value(1,false)
	set_collision_layer_value(2,true)
	set_collision_mask_value(1,false)
	set_collision_mask_value(2,true)

func clamping_values():
	velocity.y=clamp(velocity.y,-MaxYSpeed,MaxYSpeed)
	
func _process(delta):
	
	
	playerPos = get_tree().root.get_child(0).get_node("PlayerTest").global_position
	
	if int(timerValue/60)>=SecToChangeDir:
		timerValue=0
		rng_dir = rng.randi_range(-1,1)
		while(rng_dir==0):
			rng_dir = rng.randi_range(-1,1)
			
func _physics_process(delta):
	
	timerValue+=1
	if playerPos.distance_to(global_position)<playerDetectRange:
		followingPlayer()
	else:
		patroling()
	clamping_values()
	if !is_on_floor():
		velocity.y+=gravity
	else:
		if is_on_wall():
			velocity.y=jump
			LandJumpAnim.play("jump")
	move_and_slide()
	
func patroling():
	if playerPos.distance_to(global_position)>10:
		Sprite.scale.x=rng_dir
	UpAnim.play("walk")
	DownAnim.play("walk")
	GeneralAnim.play("walk")
	
	if rng_dir>0:
		if velocity.x<patrollingSpeed:
				velocity.x += accelleration 
	else:
		if velocity.x>-patrollingSpeed:
				velocity.x -= accelleration 

	
func followingPlayer():
	if playerPos.distance_to(global_position)>10:
		Sprite.scale.x=playerDir
	UpAnim.play("walkAttack")
	DownAnim.play("walkAttack")
	GeneralAnim.play("walkAttack")
	
		
	if playerPos.distance_to(global_position)>10:
		if global_position.x<playerPos.x:
			if velocity.x<attackingSpeed:
				velocity.x += accelleration 
			playerDir=1
		else:
			if velocity.x>-attackingSpeed:
				velocity.x -= accelleration 
			playerDir=-1
			
		#velocity.x += playerDir*accelleration 
	#velocity.x=clamp(velocity.x,-attackingSpeed,attackingSpeed)
	
func applyKnockBack(value,xPos):
	var knockBackDir
	if xPos>global_position.x:
		knockBackDir=-1
	else:
		knockBackDir=1
	velocity.x=value*knockBackDir
	
