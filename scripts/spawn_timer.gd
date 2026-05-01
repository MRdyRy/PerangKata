extends Node2D

@export var zombie_scene : PackedScene = preload("res://scenes/zombie.tscn")

@onready var spawn_timer : Timer = $Timer

var base_wait_time = 3.0
var min_wait_time = 1.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	GameManager.game_started.connect(_on_game_start)
	GameManager.game_over.connect(_on_game_over)
	
func _on_game_start():
	_update_timer_speed()
	spawn_timer.start()
	
func _update_timer_speed():
	var new_wait_time = max(min_wait_time, base_wait_time - (GameManager.level * 0.2))
	spawn_timer.wait_time = new_wait_time

func _on_game_over():
	spawn_timer.stop()
	
func _on_spawn_timer_timeout():
	_spawn_zombie()
	_update_timer_speed()
	
func _spawn_zombie():
	if not GameManager.is_game_started: return
	
	# 1. Instance zombie baru
	var zombie = zombie_scene.instantiate()
	
	# 2. Tentukan posisi spawn (di luar layar kanan)
	# X = 1350 (Resolusi kita 1280, jadi 1350 ada di luar sedikit)
	# Y = Acak antara area atas dan bawah jalur lari (misal 300 sampai 550)
	var spawn_pos = Vector2(1350, randf_range(300, 550))
	zombie.position = spawn_pos
	
	# 3. Masukkan ke dalam Scene Tree
	# Gunakan get_parent() atau panggil node khusus "EnemyContainer" agar rapi
	get_parent().add_child(zombie)
