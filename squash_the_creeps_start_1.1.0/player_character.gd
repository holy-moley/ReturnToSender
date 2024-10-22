extends CharacterBody3D

@export var DEFAULT_SPEED = 15
@export var  DEFAULT_JUMP_VELOCITY = 10
@export var  DEFAULT_GRAVITY = 20
@export var  DEFAULT_SENSITIVITY = .7

@onready var storedSpeed = DEFAULT_SPEED
@onready var storedJumpVel = DEFAULT_JUMP_VELOCITY
@onready var storedGravity = DEFAULT_GRAVITY
@onready var storedSens = DEFAULT_SENSITIVITY
@onready var rotation_speed = 2.0

#func _ready():
	# Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#set_floor_max_angle(deg_to_rad(15))

#func _input(event):
	#if event is InputEventMouseMotion:
		#rotate_y(deg_to_rad((-event.relative.x * DEFAULT_SENSITIVITY)))
		#
		#$Pivot.rotate_x(deg_to_rad(event.relative.y * DEFAULT_SENSITIVITY * .5))
		#$Pivot.rotation.z = clamp($Pivot.rotation.z, deg_to_rad(-45), deg_to_rad(45))
func _process(delta: float) -> void:
	update_camera_rotation(delta)

func update_camera_rotation(delta):
	var input_vector = Vector2()
	if Input.is_action_pressed("left"):
		input_vector.x = +1
	elif Input.is_action_pressed("right"):
		input_vector.x = -1
		
	$CameraPivot.rotate_y(input_vector.x * rotation_speed * delta)
	
	

func _physics_process(delta):
	# _climbing(8)
	
	# Add the DEFAULT_GRAVITY.
	if not is_on_floor():
		velocity.y -= DEFAULT_GRAVITY * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and not Input.is_action_pressed("shift") and is_on_floor() and DEFAULT_GRAVITY != 0:
		velocity.y = DEFAULT_JUMP_VELOCITY
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction and DEFAULT_GRAVITY != 0:
		if is_on_floor():
			velocity.x = direction.x * DEFAULT_SPEED
			velocity.z = direction.z * DEFAULT_SPEED
			# $catMesh/AnimationPlayer.play("ArmatureAction")
		else:
			velocity.x = direction.x * DEFAULT_SPEED * .5
			velocity.z = direction.z * DEFAULT_SPEED * .5
	else:
		var startingXVel = velocity.x
		var startingZVel = velocity.z
		velocity.x = move_toward(velocity.x, startingXVel/2, DEFAULT_SPEED*.5)
		velocity.z = move_toward(velocity.z, startingZVel/2, DEFAULT_SPEED*.5)
		
	$Pivot.basis = Basis.looking_at(direction)

	move_and_slide()


var facingSomething = false
#func _climbing(heightLimit):
	#if self.get_last_slide_collision():
		#var collider = self.get_last_slide_collision().get_collider()
		#var climbable = false
		##checking for climbable layer staticBodies
		#if collider.get_class() == "StaticBody3D":
			#if collider.get_collision_layer_value(2):
				##print(collider)
				#climbable = true
				#var heightDiff = findCubePlayerHeightDiff(collider)
				##print(heightDiff)
				#if heightDiff > heightLimit:
					##print("cant climb")
					#return
		##finding face closest to player
		#if climbable and is_on_wall() and facingSomething and Input.is_action_pressed("forward"):
			##print("climbing")
			#var wallVector = get_wall_normal()
			#var climbDirection = transform.basis * Vector3(0,1,0)
			#velocity.y = climbDirection.y * DEFAULT_SPEED * .5
			#
func findCubePlayerHeightDiff(obj):
	return obj.position.y + obj.scale.y - position.y


func _on_facing_check_body_entered(body):
	facingSomething = true


func _on_facing_check_body_exited(body):
	facingSomething = false
