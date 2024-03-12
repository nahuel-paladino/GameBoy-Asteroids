extends Area2D

@export var damage = 1
@export var speed = 75

func _physics_process(delta: float) -> void:
	position -= transform.y * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: PhysicsBody2D) -> void:
	if body is Asteroid:
		body.take_damage(damage)
		queue_free()
	

