extends CharacterBody2D

#data
var word = "" #target word
var current_index = 0  #progress huruf
var speed = 100.0 #zombie movement
var is_dead = false #status


var difficulty : WordManager.Difficulty

# reference
@onready var label = $RichTextLabel
@onready var sprite = $AnimatedSprite2D
@onready var animation = $AnimationPlayer
@onready var hit_box : Area2D = $HitBox
@onready var explode = $AnimatedSprite2D2
@onready var dead_sound = $tech_death
@onready var slash_sound = $explode_sound
@onready var combo_hit = $combo_label

# variable _name = local
# variable tanpa _ didepan = public
func _ready() -> void:
	add_to_group("enemies")
	difficulty = WordManager.get_difficulty_enum(GameManager.level)
	print("Enemies spawn with level : ",difficulty)
	word = WordManager.get_random_word(difficulty)
	print("Word is : ", word)
	label.text = word.to_upper()
	set_difficulty_setting()
	animation.play(_get_walk_anim(difficulty))
	hit_box.area_entered.connect(_on_hit_box_body_entered)
	explode.hide()
	if "InputManager" in get_node("/root"):
		get_node("/root/InputManager").refresh_all_zombies_visual()	
	

##word
#func set_word(new_word : String, diff:WordManager.Difficulty):
	#word = new_word
	#current_index = 0
	#difficulty = diff
##	set level
	#set_difficulty_setting()
##	refresh rendering
	#update_text()
	#sprite.play(get_walk_anim(diff))
	
	
func _update_visual_text():
	var correct = word.substr(0, current_index).to_upper()
	var remaining = word.substr(current_index).to_upper()
	label.bbcode_enabled = true
	var color_code = "#00ff00"
	label.text = "[center][color=%s]%s[/color]%s[/center]" % [color_code, correct, remaining]

func _get_walk_anim(difficulty:WordManager.Difficulty)-> String :
	match difficulty:
		WordManager.Difficulty.EASY: return "easy_walk"
		WordManager.Difficulty.MEDIUM: return "medium_walk"
		WordManager.Difficulty.HARD: return "hard_walk"
		WordManager.Difficulty.BOSS: return "hard_walk"
		_: return ""
		
func _get_hurt_anim(difficulty:WordManager.Difficulty)-> String :
	match difficulty:
		WordManager.Difficulty.EASY: return "easy_hurt"
		WordManager.Difficulty.MEDIUM: return "medium_hurt"
		WordManager.Difficulty.HARD: return "hard_hurt"
		WordManager.Difficulty.BOSS: return "hard_hurt"
		_: return ""

func _get_die_anim(difficulty:WordManager.Difficulty)-> String :
	match difficulty:
		WordManager.Difficulty.EASY: return "easy_die"
		WordManager.Difficulty.MEDIUM: return "medium_die"
		WordManager.Difficulty.HARD: return "hard_die"
		WordManager.Difficulty.BOSS: return "hard_die"
		_: return ""
		
func handle_input(char:String) -> void :
	print("question : ", word)
	print("on zombie scene :typing : ", char)
	if is_dead:
		return
	var target_char = word[current_index].to_upper()
	var input_char = char.to_upper()
	if target_char == input_char:
		print("correct char : ", char)
		GameManager.hero_attack_triggered.emit()
		current_index += 1
		_update_visual_text()
		
		var player = get_tree().get_first_node_in_group("player")
		if player:
			var enemy_position = self.global_position
			enemy_position.y += 500
			GameManager.spawn_splash(player.global_position, enemy_position)
		
		if dead_sound.stream:
			dead_sound.play()
		
		animation.play(_get_hurt_anim(difficulty))
		animation.queue(_get_walk_anim(difficulty))
	else :
#		reset
		if GameManager.combo > 1 :
			GameManager.combo = 0
			GameManager.shake_strength = 0
	if current_index >= word.length():
		print("completed")
		explode.show()
		var enemy_explode = self.global_position
		enemy_explode.y +=300
		enemy_explode.x -=100
		explode.position = self.global_position
		explode.play("default")
		on_word_complete()
		show_combo(GameManager.combo)
		
func on_word_complete():
	is_dead = true
	InputManager.current_target_zombie = null
	GameManager.add_combo()
	print("score : ",GameManager.ink_droplets)
	hit_box.set_deferred("monitoring",false)
	animation.play(_get_die_anim(difficulty))
	await animation.animation_finished
	if slash_sound.stream:
		slash_sound.play()
	queue_free()

#func on_correct_input():
	#_update_visual_text()
	#player_hit_effect()
	#if not is_dead:
		#sprite.play("hit")
		#await sprite.animation.finished
		#
		#sprite.play(get_walk_anim(difficulty))
		
	
func player_hit_effect():
	modulate = Color(1,1,1,2)
	await get_tree().create_timer(0.05).timeout
	modulate = Color(1,1,1,1)
	
	scale *= 1.1
	await get_tree().create_timer(0.05).timeout
	scale /=1.1
	
	
func set_difficulty_setting():
	match difficulty :
		WordManager.Difficulty.EASY:
			speed = 70
			scale = Vector2(1,1)
		WordManager.Difficulty.MEDIUM:
			speed = 100
			scale = Vector2(1,1)
		WordManager.Difficulty.HARD:
			speed = 130
			scale = Vector2(1,1)
		WordManager.Difficulty.BOSS:
			speed = 50
			scale = Vector2(1.5, 1.5)
			
func _physics_process(delta: float) -> void:
	velocity.x = -speed
	move_and_slide()


func _on_hit_box_body_entered(area: Node2D) -> void:
	print("zombie enter player zone")
	if area.is_in_group("player") or area.get_parent().is_in_group("player"):
		print("on zombie scene : hitbox touch")
		GameManager.trigger_game_over()

func show_combo(combo):
	if combo >1:
		GameManager.shake_strength += combo
		#combo_hit.text = "COMBO X %d" % combo
		combo_hit.text = "%d x🔥" % combo
		combo_hit.scale = Vector2(1.5, 1.5)
		if GameManager.combo < 3:
			combo_hit.modulate = Color(1,1,0)
		else :
			combo_hit.modulate = Color(1,0,0)
		var max_scale = 1
		if combo < 5 :
			max_scale = combo
		else :
			max_scale = 8
		var tween = create_tween()
		tween.tween_property(combo_hit, "scale", Vector2(max_scale, max_scale),0.2)
		tween.tween_property(combo_hit, "modulate", Color(1,1,1),0.2)
