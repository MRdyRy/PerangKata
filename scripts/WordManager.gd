extends Node

#level
enum Difficulty {
	EASY,
	MEDIUM,
	HARD,
	BOSS
}
# collection word from json
var word_bank: Dictionary = {}

# path to resource question.json
const PATH_QUESTIONS = "res://data/questions.json"

func _ready() -> void:
	load_word()

func load_word() :
	if not FileAccess.file_exists(PATH_QUESTIONS):
		push_error("Failed to load question assets!")
		print_debug("File : ",PATH_QUESTIONS, " not found!")
		word_bank = {"easy":["error"],"medium":["system-error"],"hard":["fatal-error"],"boss":["system-down"]}
		return
	var file = FileAccess.open(PATH_QUESTIONS, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(json_string)
	
	if error == OK:
		var data = json.data
		if typeof(data) == TYPE_DICTIONARY:
			word_bank = data
			print(str(word_bank.keys().size())+" Questions assets successfully loaded!")
		else :
			push_error("Failed to load question assets, must be dictionary!")
	else :
		push_error("General error : ",json.get_error_message()," on line ", json.get_error_line())

#get random word based on level difficulty
func get_random_word(diff:Difficulty = Difficulty.EASY)->String :
	var diff_string = Difficulty.keys()[diff].to_lower()
	
	if word_bank.has(diff_string):
		var list = word_bank[diff_string]
		if list.size() > 0 :
			return list[randi() % list.size()]
			
	return "PerangKata"
	
#helper
func get_difficulty_enum (level : int) -> Difficulty :
	if level >= 15:
		return Difficulty.BOSS
	elif level >= 10:
		return Difficulty.HARD
	elif level >= 5:
		return Difficulty.MEDIUM
	else :
		return Difficulty.EASY
