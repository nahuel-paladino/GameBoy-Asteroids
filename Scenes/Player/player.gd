extends CharacterBody2D

const Bullet = preload("res://Scenes/Player/bullet.tscn")

@export var rotation_speed: float = 3 # radians/sec
@export var speed: int = 50 # pixels/sec
@export_range(0.0, 1.0) var acceleration: float = 0.2 # used for speedup lerp
@export_range(0.0, 1.0) var friction: float = 0.05 # used for slowdown lerp

var screen_size

@onready var fire_delay_timer: Timer = $FireDelay

func _ready() -> void:
	screen_size = get_viewport_rect().size


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("shoot") && fire_delay_timer.is_stopped():
		shoot()
	
	# update facing direction
	var rotation_direction: float = Input.get_axis("turn_left", "turn_right")
	rotation += rotation_direction * rotation_speed * delta
	
	# motion smoothing with interpolation
	if Input.is_action_pressed("accelerate"):
		velocity = lerp(velocity, Vector2.UP.rotated(rotation) * speed, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
	
	move_and_slide()
	
	# keep player on-screen
	position = position.clamp(
			Vector2(5.0, 5.0), Vector2(screen_size.x - 5.0, screen_size.y - 5.0)
		)


func start(start_pos: Vector2) -> void:
	position = start_pos

	
func shoot() -> void:
	var bullet = Bullet.instantiate()
	bullet.transform = $BulletMarker.global_transform
	owner.add_child(bullet)
	fire_delay_timer.start()
	
