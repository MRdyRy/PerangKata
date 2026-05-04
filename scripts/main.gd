extends Node2D

@onready var main_menu = $MainMenu
@onready var parallax_bg = $BgAnimation
@onready var game_over_hud = $CanvasLayer/GameOverLabel
@onready var score_hud = $CanvasLayer/Score
@onready var sum_score_hud = $CanvasLayer/SumScore
@onready var cameramen = $Camera2D
@onready var backsound = $AudioStreamPlayer2D

# Leaderboard
@onready var player_input_name = $CanvasLayer/PlayerInpurName
@onready var top_leaderboard = $CanvasLayer/TopPlayerLeaderboard
@onready var btn_show_leaderboard = $CanvasLayer/ButtonShowLeaderboard
@onready var btn_submit_score = $CanvasLayer/SubmitScore
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu.visible = true
	game_over_hud.hide()
	_control_leaderboard(false)
	_control_game_over(false)
	top_leaderboard.visible = false
	GameManager.game_started.connect(_on_game_started)
	GameManager.game_over.connect(_on_game_over)
	GameManager.stats_updated.connect(_update_hud)
	
			
	for connection in GameManager.game_over.get_connections():
		print("Koneksi Sinyal: ", connection)
		
func _on_game_started():
	main_menu.visible = false
	_control_leaderboard(false)
	_control_game_over(false)
	print("game started, main menu disabled")
	game_over_hud.hide()
	

func _on_game_over():
	game_over_hud.show()
	print("game over hud show, with position : ",game_over_hud.position)
	var tween = create_tween()
	tween.tween_property(game_over_hud, "modulate:a", 0.7, 0.5)
	
	_control_game_over(true)
	_control_leaderboard(true)
	

func _on_main_menu_button_pressed () :
	print("back to home trigger")
	main_menu.show_menu()

func _update_hud():
	pass

func _control_game_over(state: bool):
	sum_score_hud.visible = state
	score_hud.visible = state
	if state :
		sum_score_hud.text = str(GameManager.ink_droplets)
		
func _control_leaderboard(state: bool):
	btn_show_leaderboard.visible = state
	player_input_name.visible = state
	btn_submit_score.visible = state

	player_input_name.grab_focus()
	
func _on_submit_score_pressed():
	top_leaderboard.visible = true
	btn_show_leaderboard.visible = false
	game_over_hud.visible = false
	player_input_name.visible = false
	btn_submit_score.visible = false
	sum_score_hud.visible = false
	score_hud.visible = false
	_backend_process_submit_score(player_input_name.text,GameManager.ink_droplets)
	player_input_name.text = ""
	
	
func _on_show_leaderboard(result, response_code, headers, body):
	top_leaderboard.visible = true
	_control_game_over(false)
	player_input_name.visible = false
	btn_submit_score.visible = false
	game_over_hud.visible = false
	sum_score_hud.visible = false
	score_hud.visible = false
	if response_code == 200:
		print("call get leaderboard from server")
	else:
		print("error on submit score")
#	to do fetch api score

func _backend_process_submit_score(name:String, score: int) :
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_show_leaderboard)
	var body = JSON.stringify({"name":name, "score": score})
	var headers = ["Content-Type:application/json"]
	http.request("http://localhost:8080/a/leaderboard/submit", headers,HTTPClient.METHOD_POST,body)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameManager.is_game_started:
		for layer in $BgAnimation.get_children():
			if layer is ParallaxLayer:
				layer.motion_offset.x -= GameManager.game_speed * delta
		
	#	test
	if GameManager.shake_strength > 0 && GameManager.combo > 0 :
		GameManager.shake_strength = lerp(float(GameManager.shake_strength), float(0), float(GameManager.shake_fade) * delta)
		cameramen.offset = Vector2(
			randf_range(-GameManager.shake_strength, GameManager.shake_strength),
			randf_range(-GameManager.shake_strength, GameManager.shake_strength))
		
