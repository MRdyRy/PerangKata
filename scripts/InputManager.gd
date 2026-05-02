extends Node

var current_target_zombie = null

func _unhandled_input(event: InputEvent) -> void:
	# 1. Validasi: Pastikan game sudah mulai
	if not GameManager.is_game_started:
		return
	# Pastikan event adalah penekanan tombol keyboard yang sah dan bukan echo
	if event is InputEventKey and event.pressed and not event.is_echo():
		print("goes here : ", event.as_text())
		# Gunakan unicode untuk mengambil karakter yang diketik
		var char_code = event.unicode
		if char_code == 0:
			return # Abaikan tombol fungsi seperti Shift, Ctrl, Alt
			
		var char_typed = char(char_code).to_lower()
		
		# Validasi karakter alfabet (a-z) menggunakan regex sederhana
		var regex = RegEx.new()
		regex.compile("[a-z]")
		
		if regex.search(char_typed):
			_route_input_to_zombie(char_typed)

func _route_input_to_zombie(typed_char: String) -> void:
	var all_zombies = get_tree().get_nodes_in_group("enemies")
	
	# 1. Jika belum ada target, cari yang paling dekat (X terkecil)
	if not is_instance_valid(current_target_zombie):
		var min_distance = 99999.0
		var potential_target = null
		
		for zombie in all_zombies:
			if is_instance_valid(zombie) and not zombie.is_dead:
				if zombie.position.x < min_distance:
					min_distance = zombie.position.x
					potential_target = zombie
		
		if potential_target:
			current_target_zombie = potential_target
			# UPDATE VISUAL: Hanya panggil saat target baru ditemukan
			_refresh_zombie_opacity(all_zombies)

	# 2. Kirim input ke target yang sudah terkunci
	if is_instance_valid(current_target_zombie):
		current_target_zombie.handle_input(typed_char)

func _refresh_zombie_opacity(zombies: Array):
	for zombie in zombies:
		if is_instance_valid(zombie):
			if zombie == current_target_zombie:
				zombie.modulate.a = 1.0  # Target tetap solid
				zombie.z_index = 10     # Layer paling depan
			else:
				zombie.modulate.a = 0.3  # Zombie lain transparan
				zombie.z_index = 1      # Layer belakang

func refresh_all_zombies_visual():
	var all_zombies = get_tree().get_nodes_in_group("enemies")
	_refresh_zombie_opacity(all_zombies)
