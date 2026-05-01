extends Node

func _unhandled_input(event: InputEvent) -> void:
	# 1. Validasi: Pastikan game sudah mulai dan input adalah karakter (bukan Shift/Alt)
	if not GameManager.is_game_started: return
	if not event is InputEventKey or not event.pressed: return
	
	# Ambil string dari tombol yang ditekan (misal: "a", "b", "1")
	var char_typed = char(event.unicode).to_lower()
	
	# Pastikan yang ditekan adalah karakter alfabet (a-z)
	if char_typed.length() > 0 and char_typed.match("[a-z]"):
		_route_input_to_zombie(char_typed)

func _route_input_to_zombie(typed_char: String) -> void:
	# 2. Ambil semua zombie yang ada di layar
	var all_zombies = get_tree().get_nodes_in_group("enemies")
	
	if all_zombies.size() == 0:
		return # Tidak ada target

	# 3. Cari Zombie terdekat (Targeting Logic)
	var target_zombie = null
	var min_distance = 9999.0
	
	for zombie in all_zombies:
		# Lewati jika zombie sedang dalam proses mati
		if zombie.has_method("is_dying") and zombie.is_dying:
			continue
			
		# Hitung jarak X (karena mereka datang dari kanan ke kiri)
		# Zombie dengan posisi X terkecil adalah yang paling dekat dengan Hero
		if zombie.position.x < min_distance:
			min_distance = zombie.position.x
			target_zombie = zombie

	# 4. Salurkan input ke zombie tersebut
	if target_zombie:
		target_zombie.handle_input(typed_char)
