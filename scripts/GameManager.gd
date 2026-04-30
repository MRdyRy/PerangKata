extends Node

# Game Stats Variable
var current_target_word : String = ""
var combo : int = 0
var ink_droplets :int = 0
var level :int = 1
var max_combo_for_ultimate :int = 10 # will play ultimate if combo 10 times

# Signal for communication scenes
signal stats_updated
signal ultimate_ready
signal typo_occured
signal game_over

# Scaling Difficulty
var game_speed :float = 200.0
var base_speed :float = 200.0
var speed_increment :float = 25.0
var game_time :float = 0.0

func add_ink(amount) :
	ink_droplets += amount
	stats_updated.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	game_time += delta
	if int(game_time) % 15 == 0 and int(game_time) != 0:
		_increase_difficulty()

func _increase_difficulty():
	level += 1
	game_speed = base_speed + (level * speed_increment)
	stats_updated.emit()
	print("Level up: ",level, " speed : ", game_speed)

func add_combo():
	combo += 1
#	add droplets for 5 zombies killed
	ink_droplets += 5 * level
	
#	check ultimate if full
	if combo >= max_combo_for_ultimate :
		ultimate_ready.emit()
	stats_updated.emit()
	
	
func reset_combo():
	combo = 0
	typo_occured.emit()
	stats_updated.emit()
	
func use_ultimate():
	if combo >= max_combo_for_ultimate :
		print("ultimate run, auto correct!")
#		reset after use
		combo = 0
		stats_updated.emit()
		return true
	return false
	
func trigger_game_over():
	print("Game over! Total Ink: ", ink_droplets)
	game_speed = 0
	game_over.emit()
#	game over menu
