
extends CharacterBody3D
# Player speed, m/s
@export var speed = 0

@export var rotation_speed = 3.0
#Gravity, m/s^2
@export var fall_acceleration = 75
@export var target_velocity = Vector3.ZERO
@export var direction = Vector3.ZERO
@export var jump_velocity = 30.0
@export var max_speed = 15
@export var forward_velocity = Vector3.ZERO
@export var player_y = 0.0
@export var start_pos = Vector3(0, 1, 0)
@export var jumping = false

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func _process(delta):
	player_y = global_transform.origin.y #Get Ypos of player

func respawn(location):
	global_transform.origin = location
	target_velocity.y = 0

func _physics_process(delta):
	print(jumping)
	print(velocity.y)
	#Respawn if player falls off the map
	if player_y <= -150:
		respawn(start_pos)
	
	if Input.is_action_pressed("respawn"):
		respawn(start_pos)
	
	 #Sets speed to 0, should be changed to make it not clunky
		
	direction = -transform.basis.z #Set direction to wherever player is looking
	if Input.is_action_pressed("left"):  
		rotate_y(rotation_speed * delta)  # Rotate left
	elif Input.is_action_pressed("right"):  
		rotate_y(-rotation_speed * delta)  # Rotate right
	if Input.is_action_pressed("back"):
		if speed > -max_speed:
			speed -= 3
	else:
		if speed < 0:
			speed += 1
		#speed = -max_speed #Set speed to negative max speed
	if Input.is_action_pressed("forward"):
		if speed < max_speed:
			speed += 3
	else:
		if speed >0:
			speed -= 1
		#speed = max_speed #Set speed to max speed
		# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		target_velocity.y = jump_velocity
	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	# Vertical Velocity
	
	if velocity.y >0: #If the velocity is positive, the player is jumping
		jumping = true
	if not is_on_floor() and jumping == true: # If jumping, fall at a normal rate
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	elif not is_on_floor() and jumping == false: #If not jumping, fall slower to make it less jarring
		target_velocity.y = target_velocity.y - (fall_acceleration/2 * delta)
	if is_on_floor(): #When on the ground, player is not jumping
		jumping = false
	# Moving the Character
	velocity = target_velocity
	#print("Velocity ", velocity)
	move_and_slide()
