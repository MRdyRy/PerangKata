extends CharacterBody2D

#data
var word = "" #target word
var current_index = 0  #progress huruf
var speed = 100.0 #zombie movement
var is_dead = false #status


var difficulty : WordManager.Difficulty


# reference
@onready var label = $WordLabel
@onready var sprite = $AnimatedSprite2D
@onready var animation = $AnimationPlayer
@onready var hit_box : Area2D = $HitBox


func _ready() -> void:
	add_to_group("enemies")
	difficulty = WordManager.get_difficulty_enum(GameManager.level)
	print("Enemies spawn with level : ",difficulty)
	word = WordManager.get_random_word(difficulty)
	print("Word is : ", word)
	label.text = word.to_upper()
	set_difficulty_setting()
	animation.play(_get_walk_anim(difficulty))
	hit_box.area_entered.connect(_on_hit_box_entered)
	
func _on_hit_box_entered(area : Area2D):
	if area.is_in_group("player") or area.get_parent().is_in_group("player"):
		GameManager.trigger_game_over()
	
	
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
	var correct = word.substr(0, current_index)
	var remaining = word.substr(current_index)
	label.bbcode_enabled = true
	label.text = "[color=green]%[/color]%" %[correct, remaining]

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
		
func _handle_input(char:String) -> void :
	if is_dead:
		return
	if word[current_index] == char.to_upper():
		current_index += 1
		_update_visual_text()
		
		animation.play(_get_hurt_anim(difficulty))
		animation.queue(_get_walk_anim(difficulty))
	if current_index >= word.length():
		on_word_complete()
		
func on_word_complete():
	is_dead = true
	GameManager.add_combo()
	hit_box.set_deferred("monitoring",false)
	animation.play(_get_die_anim(difficulty))
	await animation.animation_finished
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
