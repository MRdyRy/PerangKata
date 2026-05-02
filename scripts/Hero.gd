extends CharacterBody2D

@onready var anim_player = $AnimationPlayer


func _ready() -> void:
#	set to group, the zombie will detect this props by group
	add_to_group("player")
#	set position
	position = Vector2(160, 640)
#	run the animation
	anim_player.play("idle")
#	connect signal on typo and game over from game manager
	GameManager.game_started.connect(_on_game_start)
	GameManager.typo_occured.connect(_on_typo_detected)
	GameManager.game_over.connect(play_death)
	GameManager.hero_attack_triggered.connect(_on_attack_triggered)
	if GameManager.is_game_started:
		print("game is started")
		_on_game_start()
	
func play_death():
	anim_player.play("death")
	set_process(false)
	set_physics_process(false)

func _on_typo_detected():
#	check current animation, play hurt and wait until finished and then run again
	if anim_player.current_animation != "hurt":
		anim_player.play("hurt")
		
		await anim_player.animation_finished
		anim_player.play("run")

#in the home screen player will idle then if user pressed button start
#the animation will play run
func _on_game_start():
	print("on scene hero, game start!")
	if anim_player.current_animation != "idle":
			anim_player.play("idle")
			print("hero idle")
			await anim_player.animation_finished
			print("hero idle selesai, hero run")
			anim_player.play("run")
	else:
		anim_player.play("run")
	
func _on_attack_triggered():
	var choice = ["attack","ultimate"]
	anim_player.play(choice.pick_random())
	await anim_player.animation_finished
	anim_player.play("run")
func _on_ultimate_triggered():
	anim_player.play("ultimate")
	await anim_player.animation_finished
	anim_player.play("run")
#func _physics_process(delta: float) -> void:
	#move_and_slide()
