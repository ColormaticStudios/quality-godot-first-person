extends Node3D


var paused = false

signal pause
signal unpause


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func pause_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#get_tree().paused = true #In case you want to pause the game
	pause.emit()

func unpause_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#get_tree().paused = false
	unpause.emit()

func _process(_delta):
	if Input.is_action_just_released("game_pause"):
		paused = !paused
		if paused:
			pause_game()
		else:
			unpause_game()
