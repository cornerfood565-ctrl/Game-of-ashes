extends Node2D
var hp := 60
var target_position := Vector2.ZERO
func _ready() -> void:
	z_index = 4
func set_target(value: Vector2) -> void:
	target_position = value
func _process(delta: float) -> void:
	if hp <= 0: return
	var distance := global_position.distance_to(target_position)
	if distance > 54 and distance < 260:
		global_position += (target_position - global_position).normalized() * 32.0 * delta
	queue_redraw()
func take_damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		hp = 0
		visible = false
		set_process(false)
		var game = get_parent()
		if game:
			game.xp += 20
			game.gold += 3
			game._show_message("Wraith defeated! +20 XP, +3 gold")
func _draw() -> void:
	if hp <= 0: return
	draw_rect(Rect2(-13, -14, 26, 30), Color("#34283f"))
	draw_rect(Rect2(-9, -20, 18, 13), Color("#68506c"))
	draw_rect(Rect2(-7, -15, 4, 3), Color("#e47b73"))
	draw_rect(Rect2(3, -15, 4, 3), Color("#e47b73"))
	draw_rect(Rect2(-9, 13, 7, 7), Color("#1a1722"))
	draw_rect(Rect2(3, 13, 7, 7), Color("#1a1722"))
	draw_rect(Rect2(-15, -28, 30, 4), Color("#241c2b"))
	draw_rect(Rect2(-15, -28, 30.0 * float(hp) / 60.0, 4), Color("#b94c59"))
