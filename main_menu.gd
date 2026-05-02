extends CanvasLayer

var is_start_pressed : bool = false
@onready var bg = $ColorRect
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_menu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func show_menu():
	$about.hide()
	$Message.show()
	$VBoxContainer.show()
	$BackButton.hide()
	bg.show()
	

func show_about():
	$about.show()
	$Message.hide()
	$VBoxContainer.hide()
	$BackButton.show()
	bg.show()


func _on_start_button_pressed() -> void:
	print("game trigger to start!")
	$about.hide()
	$Message.hide()
	$VBoxContainer.hide()
	$BackButton.hide()
	bg.hide()
	is_start_pressed = true
	GameManager.start_game()
	
