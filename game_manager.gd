class_name GameManager
extends Node

signal toggle_game_paused(is_paused: bool)

var game_paused: bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		toggle_game_paused.emit(game_paused)


func _ready() -> void:
	$Level/Spawner.add_score.connect(_on_add_score)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		game_paused = !game_paused


func _on_add_score(score) -> void:
	$CanvasLayer/HUD.increment_score(score)
