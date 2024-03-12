class_name Asteroid
extends RigidBody2D

signal destroyed(asteroid: Asteroid)
signal screen_exited

enum Size {
	LARGE,
	MEDIUM,
	SMALL,
}

@export var size: Size:
	set = set_size

# value to multiply scale by
# e.g. 0.5 = 1/2 size, 0.25 = 1/4 size, etc.
@export var large_scale := 0.5
@export var medium_scale := 0.35
@export var small_scale := 0.2

# player bullet always does 1 damage
@export var large_health := 10
@export var medium_health := 5
@export var small_health := 3

@export var large_points := 100
@export var medium_points := 50
@export var small_points := 25

var health: int
var point_value: int

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	screen_exited.emit()
	queue_free()


func set_size(asteroid_size: Size):
	size = asteroid_size
	match asteroid_size:
		Size.LARGE:
			health = large_health
			point_value = large_points
			_scale_children(large_scale)
		Size.MEDIUM:
			health = medium_health
			point_value = medium_points
			_scale_children(medium_scale)
		Size.SMALL:
			health = small_health
			point_value = small_points
			_scale_children(small_scale)


func take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		_destroy()


func _destroy() -> void:
	destroyed.emit(self)
	queue_free()


# RigidBody2D cannot be scaled directly, therefore scale its children
func _scale_children(scale_ratio: float) -> void:
	var scale_vector = Vector2(scale_ratio, scale_ratio)
	var children = get_children()
	for child in children:
		child.scale = scale_vector

