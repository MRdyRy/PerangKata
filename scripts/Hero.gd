extends CharacterBody2D

@onready var anim_player = $AnimationPlayer


func _ready() -> void:
#	set to group, the zombie will detect this props by group
	add_to_group("player")
#	set position
	position = Vector2(200, 450)
#	run the animation
	anim_player.play("idle")
#	connect signal on typo and game over from game manager
	GameManager.game_started.connect(_on_game_start)
	GameManager.typo_occured.connect(_on_typo_detected)
	GameManager.game_over.connect(play_death)
	
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

func _on_game_start():
#in the home screen player will idle then if user pressed button start
#the animation will play run
	if anim_player.current_animation != "idle":
			anim_player.play("idle")
			
			await anim_player.animation_finished
			anim_player.play("run")
	
func _physics_process(delta: float) -> void:
	move_and_slide()
