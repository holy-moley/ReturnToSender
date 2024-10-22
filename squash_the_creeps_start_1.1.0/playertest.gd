
extends CharacterBody3D
# Player speed, m/s
@export var speed = 0

@export var rotation_speed = 2.0
#Gravity, m/s^2
@export var fall_acceleration = 75
@export var target_velocity = Vector3.ZERO
@export var direction = Vector3.ZERO
@export var jump_velocity = 20.0
@export var max_speed = 15
@export var forward_velocity = Vector3.ZERO
@export var player_y = 0.0
@export var start_pos = Vector3(0, 1, 0)

func _process(delta):
	player_y = global_transform.origin.y #Get Ypos of player

func _physics_process(delta):
	#Respawn if player falls off the map
	if player_y <= -150:
		global_transform.origin = start_pos
		target_velocity.y = 0
	
	speed = 0 #Sets speed to 0, should be changed to make it not clunky
		
	direction = -transform.basis.z #Set direction to wherever player is looking
	if Input.is_action_pressed("left"):  
		rotate_y(rotation_speed * delta)  # Rotate left
	elif Input.is_action_pressed("right"):  
		rotate_y(-rotation_speed * delta)  # Rotate right
	if Input.is_action_pressed("back"):
		speed = -max_speed #Set speed to negative max speed
	if Input.is_action_pressed("forward"):
		speed = max_speed #Set speed to max speed
		# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		target_velocity.y = jump_velocity

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	# Moving the Character
	velocity = target_velocity
	#print("Velocity ", velocity)
	move_and_slide()
