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
@export var deadFinished : bool = false
@export var ObjectToSpawn : Array
#@export var ObjectToProb : Array
@export var decell : int = 5
@export var knockBackResistence : float = 1
@export var knockBack : int = 100
@export var hp : int = 100
@export var MaxHp : int = 100
@export var jump : int = -400
@export var patrollingSpeed : int = 40
@export var attackingSpeed : int = 80
@export var playerDetectRange : int = 200
@export var gravity : int = 13
@export var MaxYSpeed : int = 1000
@export var damage : int
@export var SecToChangeDir : int = 5
@export var accelleration : int = 5
@onready var playerPos #= get_tree().root.get_child(0).get_node("PlayerTest").global_position
@onready var player
@onready var UpAnim = get_node("UpAnimationManager")
@onready var DownAnim = get_node("DownAnimationManager")
@onready var LandJumpAnim = get_node("LandJumpAnimationManager")
@onready var GeneralAnim = get_node("GeneralAnimationManager")
@onready var DamageAnim = get_node("Damage")
@onready var Sprite = get_node("DirectionScaler")
@onready var LifeBar : TextureProgressBar = get_node("LifeBar")
var alive = true
var rng = RandomNumberGenerator.new()
var rng_dir : int = 1
var playerDir : int = 0
var timerValue = 0


func _ready():
	player=searchPlayer.new().do(get_tree().root.get_child(0))
	playerPos = player.global_position
	LifeBar.max_value=hp
	MaxHp=hp
	rng.randomize()
	set_collision_layer_value(1,false)
	set_collision_layer_value(2,true)
	set_collision_mask_value(1,false)
	set_collision_mask_value(2,true)

func clamping_values():
	velocity.y=clamp(velocity.y,-MaxYSpeed,MaxYSpeed)
	
func _process(delta):
	if deadFinished:
		spawnObj()
		queue_free()
	alive=hp>0
	LifeBar.visible=hp!=MaxHp and hp>0
	LifeBar.value=hp
	playerPos = player.global_position
	
	if int(timerValue/60)>=SecToChangeDir:
		timerValue=0
		rng_dir = rng.randi_range(-1,1)
		while(rng_dir==0):
			rng_dir = rng.randi_range(-1,1)
			
func _physics_process(delta):
	timerValue+=1
	if  alive:
		if playerPos.distance_to(global_position)<playerDetectRange:
			
			followingPlayer()
		else:
			patroling()
			
	else:
		velocity.x=0
		dead()
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
	if velocity.x<-patrollingSpeed:
		velocity.x+=decell
	if velocity.x>patrollingSpeed:
		velocity.x-=decell
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
	velocity.x=(value*knockBackDir)*knockBackResistence
	velocity.y=-(value*0.5)*knockBackResistence
	
func applyDamage(value):
	if alive:
		hp-=value
		DamageAnim.play("damaged")
		
func dead():
	UpAnim.play("RESET")
	GeneralAnim.play("dead")


func _on_general_animation_manager_animation_finished(anim_name):
	if anim_name=="dead":
		pass
func spawnObj():
	if len(ObjectToSpawn)>0:
			var n = rng.randi_range(0,100)
			for i in ObjectToSpawn:
				if i[1].y>n and i[1].x<n:
					var ObjContainer = load("res://ToolsRes/ToolContainer.tscn").instantiate()
					ObjContainer.object=i[0].instantiate()
					ObjContainer.global_position=global_position
					get_tree().root.get_child(0).add_child(ObjContainer)
	
func saveTimeStamp():
	var save_game = FileAccess.open("res://savegame.save", FileAccess.WRITE)
	var unix_time: float = Time.get_unix_time_from_system()
	var datetime_dict: Dictionary = Time.get_datetime_dict_from_unix_time(unix_time)
	var  json_string=str(datetime_dict)
	save_game.store_line(json_string)
