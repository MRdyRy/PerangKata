extends CanvasLayer


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

func show_about():
	$about.show()
	$Message.hide()
	$VBoxContainer.hide()
	$BackButton.show()
