extends Node2D
const PLAYER_SCRIPT = preload("res://scripts/player.gd")
const ENEMY_SCRIPT = preload("res://scripts/enemy.gd")
const WORLD_SIZE := Vector2(1800, 1100)
var player: CharacterBody2D
var enemies: Array[Node2D] = []
var hp := 100
var xp := 0
var gold := 0
var quest_stage := 0
var combat_mode := 0
var turn_ready := true
var joystick := Vector2.ZERO
var joystick_origin := Vector2(105, 420)
var joystick_active := false
var hud: CanvasLayer
var status_label: Label
var quest_label: Label
var message_label: Label
var mode_button: Button
var world_time := 0.0
var message_time := 0.0

func _ready() -> void:
	_build_world()
	_build_player()
	_build_hud()
	_update_hud()

func _build_world() -> void:
	for i in range(9):
		var e := ENEMY_SCRIPT.new()
		e.position = Vector2(560 + (i % 3) * 300, 260 + int(i / 3) * 260)
		e.name = "AshWraith_%d" % i
		add_child(e)
		enemies.append(e)

func _build_player() -> void:
	player = PLAYER_SCRIPT.new()
	player.position = Vector2(170, 520)
	add_child(player)
	var camera := Camera2D.new()
	camera.enabled = true
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 5.0
	player.add_child(camera)

func _build_hud() -> void:
	hud = CanvasLayer.new()
	add_child(hud)
	var panel := Panel.new()
	panel.position = Vector2(12, 12)
	panel.size = Vector2(310, 94)
	hud.add_child(panel)
	status_label = Label.new()
	status_label.position = Vector2(12, 10)
	status_label.add_theme_font_size_override("font_size", 18)
	panel.add_child(status_label)
	quest_label = Label.new()
	quest_label.position = Vector2(16, 116)
	quest_label.add_theme_font_size_override("font_size", 16)
	hud.add_child(quest_label)
	message_label = Label.new()
	message_label.position = Vector2(350, 18)
	message_label.size = Vector2(350, 40)
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message_label.add_theme_font_size_override("font_size", 18)
	hud.add_child(message_label)
	mode_button = _make_button("MODE: REAL-TIME", Vector2(720, 18), Vector2(220, 48))
	mode_button.pressed.connect(_toggle_mode)
	var attack_button := _make_button("ATTACK", Vector2(805, 410), Vector2(125, 90))
	attack_button.pressed.connect(_attack)
	var interact_button := _make_button("INTERACT", Vector2(650, 440), Vector2(125, 60))
	interact_button.pressed.connect(_interact)
	var save_button := _make_button("SAVE", Vector2(12, 475), Vector2(100, 48))
	save_button.pressed.connect(save_game)
	var load_button := _make_button("LOAD", Vector2(122, 475), Vector2(100, 48))
	load_button.pressed.connect(load_game)

func _make_button(caption: String, pos: Vector2, dimensions: Vector2) -> Button:
	var b := Button.new()
	b.text = caption
	b.position = pos
	b.size = dimensions
	b.add_theme_font_size_override("font_size", 17)
	hud.add_child(b)
	return b

func _process(delta: float) -> void:
	world_time += delta
	if message_time > 0:
		message_time -= delta
		if message_time <= 0 and is_instance_valid(message_label):
			message_label.text = ""
	if is_instance_valid(player):
		player.move_input = joystick
		for enemy in enemies:
			if is_instance_valid(enemy):
				enemy.set_target(player.global_position)
				if combat_mode == 0 and enemy.hp > 0 and enemy.global_position.distance_to(player.global_position) < 34 and world_time > 1.0 and int(world_time * 2.0) % 3 == 0:
					hp = maxi(0, hp - 1)
		_update_hud()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, WORLD_SIZE), Color("#24212b"))
	for x in range(0, 1800, 48):
		for y in range(0, 1100, 48):
			var c := Color("#292632") if ((x / 48 + y / 48) % 2 == 0) else Color("#25222e")
			draw_rect(Rect2(x, y, 46, 46), c)
	for i in range(18):
		var p := Vector2(90 + (i * 173) % 1600, 90 + (i * 97) % 900)
		draw_rect(Rect2(p, Vector2(18, 8)), Color("#51404b"))
	draw_rect(Rect2(0, 475, 1800, 110), Color("#39313a"))
	for p in [Vector2(350, 260), Vector2(350, 690), Vector2(1220, 250), Vector2(1450, 760)]:
		draw_rect(Rect2(p, Vector2(130, 100)), Color("#51404a"))
		draw_rect(Rect2(p + Vector2(12, 12), Vector2(106, 76)), Color("#302934"))
	draw_rect(Rect2(850, 465, 64, 64), Color("#a34c55"))
	draw_rect(Rect2(862, 477, 40, 40), Color("#e1a36c"))

func _toggle_mode() -> void:
	combat_mode = 1 - combat_mode
	mode_button.text = "MODE: TURN-BASED" if combat_mode == 1 else "MODE: REAL-TIME"
	_show_message("Combat style changed.")

func _attack() -> void:
	if combat_mode == 1 and not turn_ready:
		_show_message("Wait for your next turn.")
		return
	var target: Node2D = null
	var best := 120.0
	for enemy in enemies:
		if is_instance_valid(enemy) and enemy.hp > 0:
			var d: float = player.global_position.distance_to(enemy.global_position)
			if d < best:
				best = d
				target = enemy
	if target == null:
		_show_message("No enemy in range.")
		return
	var damage := 35 if combat_mode == 1 else 20
	target.take_damage(damage)
	_show_message("Shadow strike! -%d HP" % damage)
	if combat_mode == 1:
		turn_ready = false
		await get_tree().create_timer(0.7).timeout
		turn_ready = true

func _interact() -> void:
	if player.global_position.distance_to(Vector2(882, 497)) < 115:
		if quest_stage == 0:
			quest_stage = 1
			_show_message("Quest started: The First Ember")
		elif quest_stage == 1:
			quest_stage = 2
			xp += 50
			gold += 15
			_show_message("Shrine awakened! +50 XP, +15 gold")
		else:
			_show_message("The shrine whispers of five lost guardians.")
	else:
		_show_message("Nothing to interact with nearby.")

func _update_hud() -> void:
	if not is_instance_valid(status_label):
		return
	status_label.text = "KINGDOM OF ASHES\nHP %d/100   XP %d   GOLD %d" % [hp, xp, gold]
	quest_label.text = "QUEST: %s" % ("Find the Ashen Shrine" if quest_stage == 0 else "Awaken the shrine" if quest_stage == 1 else "The First Ember — Complete")

func _show_message(value: String) -> void:
	message_label.text = value
	message_time = 2.8

func save_game() -> void:
	var data := {"hp": hp, "xp": xp, "gold": gold, "quest_stage": quest_stage, "player_x": player.position.x, "player_y": player.position.y, "combat_mode": combat_mode}
	var f := FileAccess.open("user://kingdom_save.json", FileAccess.WRITE)
	f.store_string(JSON.stringify(data))
	_show_message("Game saved.")

func load_game() -> void:
	if not FileAccess.file_exists("user://kingdom_save.json"):
		_show_message("No save found.")
		return
	var parsed = JSON.parse_string(FileAccess.get_file_as_string("user://kingdom_save.json"))
	if typeof(parsed) == TYPE_DICTIONARY:
		hp = int(parsed.get("hp", 100))
		xp = int(parsed.get("xp", 0))
		gold = int(parsed.get("gold", 0))
		quest_stage = int(parsed.get("quest_stage", 0))
		player.position = Vector2(float(parsed.get("player_x", 170)), float(parsed.get("player_y", 520)))
		combat_mode = int(parsed.get("combat_mode", 0))
		mode_button.text = "MODE: TURN-BASED" if combat_mode == 1 else "MODE: REAL-TIME"
		_show_message("Save loaded.")

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and event.position.x < 260 and event.position.y > 260:
			joystick_active = true
			_update_joystick(event.position)
		elif not event.pressed:
			joystick_active = false
			joystick = Vector2.ZERO
	elif event is InputEventScreenDrag and joystick_active:
		_update_joystick(event.position)
	elif event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE: _attack()
		elif event.keycode == KEY_E: _interact()
		elif event.keycode == KEY_TAB: _toggle_mode()
		elif event.keycode == KEY_S: save_game()

func _update_joystick(pos: Vector2) -> void:
	joystick = (pos - joystick_origin).limit_length(70) / 70.0
