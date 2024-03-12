extends Node

signal add_score(amount: int)

const AsteroidScene = preload("res://Scenes/Enemies/asteroid.tscn")

@export_range(0, 20) var spawn_max: int = 5

@onready var count: int = 0

func _on_spawn_timer_timeout() -> void:
	if count < spawn_max:
		spawn_asteroid()


func _on_asteroid_destroyed(asteroid: Asteroid) -> void:
	count -= 1
	add_score.emit(asteroid.point_value)
	print("destroyed signal received at %v" % asteroid.position)
	
	
func _on_asteroid_screen_exited() -> void:
	count -= 1


func spawn_asteroid() -> void:
	count += 1
	var asteroid = AsteroidScene.instantiate()
	
	# connect signals from each instance
	asteroid.destroyed.connect(_on_asteroid_destroyed)
	asteroid.screen_exited.connect(_on_asteroid_screen_exited)
	
	# choose random size
	asteroid.set_size(randi_range(0, 2))
	
	# choose random point along spawn path
	var spawn_location = $SpawnPath/SpawnLocation
	spawn_location.progress_ratio = randf()
	
	# set perpendicular to path direction
	var direction = spawn_location.rotation + PI / 2
	
	# set position
	asteroid.position = spawn_location.position
	
	# add deviation to direction (-30° --> +30°)
	direction += randf_range(-PI / 6, PI / 6)
	asteroid.rotation = direction
	
	# set speed
	var velocity = Vector2(randf_range(10.0, 25.0), 0.0)
	asteroid.linear_velocity = velocity.rotated(direction)
	
	add_child(asteroid)

