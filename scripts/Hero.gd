extends CharacterBody2D

@onready var anim_player = $AnimationPlayer


func _ready() -> void:
	anim_player.play("run")
	
func play_death():
	anim_player.play("die")
	set_process(false)

func _on_typo_detected():
	if anim_player.current_animation != "stumble":
		anim_player.play("stumble")
		
		await anim_player.animation_finished
		anim_player.play("run")
	
