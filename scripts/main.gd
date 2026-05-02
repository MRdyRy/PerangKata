extends Node2D

@onready var main_menu = $MainMenu
@onready var parallax_bg = $BgAnimation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu.visible = true
	
	if main_menu.is_start_pressed:
		GameManager.game_started.connect(_on_game_started)
		GameManager.game_over.connect(_on_game_over)
		GameManager.stats_updated.connect(_update_hud)
		
func _on_game_started():
	main_menu.visible = false
	print("game started, main menu disabled")

func _on_game_over():
	main_menu.visible = true
	main_menu.show_menu()

func _update_hud():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameManager.is_game_started:
		for layer in $BgAnimation.get_children():
			if layer is ParallaxLayer:
				layer.motion_offset.x -= GameManager.game_speed * delta
