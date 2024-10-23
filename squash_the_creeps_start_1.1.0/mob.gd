extends CharacterBody3D

#Min/max speed of mob in m/s
@export var min_speed = 10
@export var max_speed = 18
@export var fall_acceleration = 75
func _physics_process(delta):
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		velocity.y = velocity.y - (fall_acceleration * delta)
	move_and_slide()

func initialize(start_pos, player_pos):
	
	#Place the mob at start_pos and rotate it towards player_pos (Player's position)
	look_at_from_position(start_pos, player_pos, Vector3.UP)
	
	#Randomly rotate the mob around 45 degrees so it doesn't
	#move toward the player directly
	rotate_y(randf_range(-PI/4, PI/4))
	#Get a random speed
	var random_speed = randi_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * random_speed
	#Get a forward velocity for a speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)


func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
