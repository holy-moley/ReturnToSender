
extends CharacterBody3D
# Player speed, m/s
@export var speed = 0

@export var rotation_speed = 3.0
#Gravity, m/s^2
@export var fall_acceleration = 75
@export var target_velocity = Vector3.ZERO
@export var direction = Vector3.ZERO
@export var jump_velocity = 22
@export var max_speed = 8
@export var max_walk_speed = 8
@export var max_run_speed = 18
@export var forward_velocity = Vector3.ZERO
@export var player_y = 0.0
@export var player_y_previous = 0.0
@export var start_pos = Vector3(76,5,-32)
@export var jumping = false
@export var velocity_previous = Vector3.ZERO
@onready var raycast = $raycast
var platform_velocity = Vector3.ZERO
var is_on_platform = false

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout


func _process(delta: float) -> void:
	if Input.is_action_pressed("sprint"):
		max_speed = max_run_speed
	else:
		max_speed = max_walk_speed

func pauseButtonPress():
	get_tree().paused = true
	show()

@onready var death_menu = get_tree().get_root().get_node("Main/Menus/DeathMenu")
@onready var end_menu = get_tree().get_root().get_node("Main/Menus/EndMenu")
signal playerDeath
signal endGame
func _ready():
	#Ensures accessible death menu.
	if death_menu:
		print("Death menu loaded.")
	else:
		print("Death menu not loaded.")
	#var traps = get_tree().get_nodes_in_group("traps")
	#for trap in traps:
		#if trap is Area3D:
			#trap.body_entered.connect(onBodyEntered)
		#else:
			#print("Found node that isn't area3d.")
	self.playerDeath.connect(onDeath)
	self.endGame.connect(onEnd)
	


func onEnd():
	openEndMenu()
func openEndMenu():
	end_menu.showMenu()

func onDeath():
	openDeathMenu()
func openDeathMenu():
	if death_menu:
		death_menu.showMenu()
		get_tree().paused=true
	else:
		print ("Death menu null, check node path.")

@onready var pl = get_tree().get_root().get_node("Main/Player")
func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("traps"):
		$Sfx/AudioStreamPlayer/Boxdead.play()
		pl.visible=false
		emit_signal("playerDeath")
	if area.is_in_group("endGoal"):
		emit_signal("endGame")





func respawn(location):
	$Sfx/AudioStreamPlayer/Boxdead.play()
	global_transform.origin = location
	target_velocity.y = 0

func _physics_process(delta):
	velocity_previous = velocity
	player_y_previous = player_y
	player_y = global_transform.origin.y #Get Ypos of player
	#Handle Respawning
	if player_y <= -150: #Respawn if player falls off the map
		respawn(start_pos)

	if Input.is_action_pressed("respawn"): #Respawn player with R key
		respawn(start_pos)
	
	#Handle Movement
	direction = -transform.basis.z #Set direction to wherever player is looking
	if Input.is_action_pressed("left"):  
		rotate_y(rotation_speed * delta)  # Rotate left
	elif Input.is_action_pressed("right"):  
		rotate_y(-rotation_speed * delta)  # Rotate right
	if Input.is_action_pressed("back"): #Move backward w/ acceleration/decceleration
		if speed > -max_speed:
			speed -= 1
		else:
			speed = -max_speed
	else:
		if speed < 0:
			speed += 1
	if Input.is_action_pressed("forward"): #Move forward w/ acceleration/decceleration

		if speed < max_speed:
			speed += 1
		else:
			speed = max_speed
	else:
		if speed >0:
			speed -= 1
	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	if is_on_platform:
		target_velocity.y=0
	# Vertical Velocity
	if velocity.y >0: #If the velocity is positive, the player is jumping
		jumping = true
	if not is_on_floor() and jumping == true: # If jumping, fall at a normal rate
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	elif not is_on_floor() and jumping == false: #If not jumping, fall slower to make it less jarring
		target_velocity.y = target_velocity.y - (fall_acceleration/1.75 * delta)
	if is_on_floor(): #When on the ground, player is not jumping
		jumping = false
	if is_on_ceiling(): #Hit ceiling and go back down
		target_velocity.y = -10
	if is_on_floor()== true and (target_velocity.x != 0 or target_velocity.z != 0) and player_y_previous < player_y: 
		target_velocity.y = get_floor_angle() #Angle movement upward when going up a slope 

	if Input.is_action_just_pressed("jump") and is_on_floor(): # Handle jump
		target_velocity.y = jump_velocity
		$Sfx/AudioStreamPlayer/Boxjump.play()
	
	if velocity_previous.y < 0 and is_on_floor():
		$Sfx/AudioStreamPlayer/Boxfell.play()
	
	velocity = target_velocity
	move_and_slide()

	apply_floor_snap()
	
	#Testing stuff, will probably scrap it	
	#if get_floor_angle() > 0:
		#rotation_degrees.x = get_floor_angle()
	#else:
		#rotation_degrees.x = 0
	#rotation_degrees.x = 30
	#print(rotation_degrees.x)
	# Moving the Character
