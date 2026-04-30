extends CharacterBody2D

#data
var word = "" #target word
var current_index = 0  #progress huruf
var speed = 100.0 #zombie movement
var is_dead = false #status

#level
enum Difficulty {
	EASY,
	MEDIUM,
	HARD,
	BOSS
}

var difficulty : Difficulty


# reference
@onready var label = $WordLabel
@onready var sprite = $AnimatedSprite2D
@onready var animation = $AnimationPlayer


#word
func set_word(new_word : String, diff:Difficulty):
	word = new_word
	current_index = 0
	difficulty = diff
#	set level
	set_difficulty_setting()
#	refresh rendering
	update_text()
	sprite.play(get_walk_anim())
	
	
func update_text():
	var correct = word.substr(0, current_index)
	var remaining = word.substr(current_index)
	label.bbcode_enabled = true
	label.text = "[color=green]%[/color]%" %[correct, remaining]

func get_walk_anim()-> String :
	match difficulty:
		Difficulty.EASY: return "walk_easy"
		Difficulty.MEDIUM: return "walk_medium"
		Difficulty.HARD: return "walk_hard"
		Difficulty.BOSS: return "walk_boss"
		_: return ""
		
func check_input(char:String) -> bool :
	if is_dead:
		return false
	if current_index>= word.length():
		return false
	if word[current_index] == char:
		current_index += 1
		
		return true
		
	return false

func on_correct_input():
	update_text()
	player_hit_effect()
	if not is_dead:
		sprite.play("hit")
		await sprite.animation.finished
		sprite.play(get_walk_anim())
	
func player_hit_effect():
	modulate = Color(1,1,1,2)
	await get_tree().create_timer(0.05).timeout
	modulate = Color(1,1,1,1)
	
	scale *= 1.1
	await get_tree().create_timer(0.05).timeout
	scale /=1.1
	
	
func set_difficulty_setting():
	match difficulty :
		Difficulty.EASY:
			speed = 70
			scale = Vector2(1,1)
		Difficulty.MEDIUM:
			speed = 100
			scale = Vector2(1,1)
		Difficulty.HARD:
			speed = 130
			scale = Vector2(1,1)
		Difficulty.BOSS:
			speed = 50
			scale = Vector2(1.5, 1.5)
