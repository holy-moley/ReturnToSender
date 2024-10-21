extends Node


@export var mob_scene: PackedScene


func _on_mob_timer_timeout():
	#Create new instance of the Mob scene
	var mob = mob_scene.instantiate()
	
	#Choose random location on SpawnPath
	#store reference to SpawnLocation node
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	
	#Span mob, add it to Main scene
	add_child(mob)
