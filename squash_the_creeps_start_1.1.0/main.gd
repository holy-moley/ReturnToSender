extends Node


@export var mob_scene: PackedScene

#func _process(delta: float) -> void:
	#print("FPS: ", Engine.get_frames_per_second())

func _on_mob_timer_timeout():
	#Create new instance of the Mob scene
	var mob = mob_scene.instantiate()
	
	#Choose random location on SpawnPath
	#store reference to SpawnLocation node
	var mob_spawn_location = $Player.position
	mob_spawn_location.x += randf_range(0,10)
	mob_spawn_location.z += randf_range(0,10)
	#get_node("SpawnPath/SpawnLocation")
	#mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player.position
	mob.initialize(mob_spawn_location, player_position)
	
	#Span mob, add it to Main scene
	add_child(mob)
