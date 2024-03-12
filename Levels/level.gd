extends Node2D

func _ready() -> void:
	$Player.start($StartPosition.position)
