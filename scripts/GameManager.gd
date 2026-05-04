extends Node

# Game Stats Variable
var is_game_started : bool = false
var current_target_word : String = ""
var combo : int = 0
var ink_droplets :int = 0
var level :int = 1

# Signal for communication scenes
signal game_started 		# signal run and spawning enemy
signal stats_updated		# update UI score, ink, and combo
signal ultimate_ready	# indicator ultimate
signal typo_occured		# trigger hurt animation
signal game_over			# game over scene
signal word_submited(typed_word: String)
signal hero_attack_triggered

# Scaling Difficulty
var game_speed :float = 0.0			# homescreen / gameover scene
var base_speed :float = 200.0		# base speed game
var speed_increment :float = 20.0	# increase speed
var max_combo_for_ultimate :int = 10 # will play ultimate if combo 10 times

# Timer logic
var game_time :float = 0.0

# Effect slash
var slash_scene : PackedScene = preload("res://scenes/slash.tscn")
var shake_strength = 0
var shake_fade = 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_game_started :
			game_time += delta
#			increse difficulty every 15 sec
			if int(game_time) % 15 == 0 and int(game_time) != 0:
				_increase_difficulty()

func start_game():
#	clean all enemy left
	get_tree().call_group("enemies", "queue_free")
#	reset internal stats
	_reset_internal_stats()
#	start the game
	is_game_started = true
	game_speed = base_speed
	print("game_speed : ", game_speed)
	game_started.emit()
	print("Game started!")

func _reset_internal_stats():
	level = 1
	ink_droplets = 0
	combo = 0
	game_time = 0.0

func _increase_difficulty():
	level += 1
	game_speed = base_speed + (level * speed_increment)
	stats_updated.emit()
	print("Level up: ",level, " speed : ", game_speed)
#	reset game time for resolve glitch redundan trigger in the same time
	game_time += 1.0

func add_combo():
	combo += 1
#	add droplets for 5 zombies killed
	ink_droplets += 5 * level
	
#	check ultimate if full
	if combo >= max_combo_for_ultimate :
		ultimate_ready.emit()
	stats_updated.emit()
	
func add_ink(amount) :
	ink_droplets += amount
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
	print("on game manager : game over trigger!")
	if not is_game_started: 
		return
	is_game_started = false
	print("Game over! Total Ink: ", ink_droplets)
	game_speed = 0
	game_over.emit()
#	game over menu

func spawn_splash(from_pos:Vector2, to_pos:Vector2):
	var slash = slash_scene.instantiate()
	get_tree().root.add_child(slash)
	slash.global_position = from_pos
	slash.look_at(to_pos)
	
	var tween = slash.create_tween()
	tween.tween_property(slash, "global_position", to_pos, 0.1)
	tween.tween_callback(slash.queue_free)
