extends Node2D

@onready var main_menu = $MainMenu
@onready var parallax_bg = $BgAnimation
@onready var game_over_hud = $CanvasLayer/GameOverLabel
@onready var back_to_home_button = $CanvasLayer/BackToHome
@onready var score_hud = $CanvasLayer/Score
@onready var sum_score_hud = $CanvasLayer/SumScore

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu.visible = true
	game_over_hud.hide()
	back_to_home_button.hide()
	score_hud.hide()
	sum_score_hud.hide()
	GameManager.game_started.connect(_on_game_started)
	GameManager.game_over.connect(_on_game_over)
	GameManager.stats_updated.connect(_update_hud)
			
	for connection in GameManager.game_over.get_connections():
		print("Koneksi Sinyal: ", connection)
		
func _on_game_started():
	main_menu.visible = false
	back_to_home_button.hide()
	print("game started, main menu disabled")
	game_over_hud.hide()
	

func _on_game_over():
	game_over_hud.show()
	print("game over hud show, with position : ",game_over_hud.position)
	var tween = create_tween()
	tween.tween_property(game_over_hud, "modulate:a", 0.7, 0.5)
	score_hud.show()
	sum_score_hud.text = str(GameManager.ink_droplets)
	sum_score_hud.show()
	#back_to_home_button.show()
	

func _on_main_menu_button_pressed () :
	print("back to home trigger")
	main_menu.show_menu()

func _update_hud():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameManager.is_game_started:
		for layer in $BgAnimation.get_children():
			if layer is ParallaxLayer:
				layer.motion_offset.x -= GameManager.game_speed * delta
