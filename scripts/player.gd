extends CharacterBody2D
var move_input := Vector2.ZERO
const SPEED := 190.0

func _ready() -> void:
	z_index = 5
	var collision := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 12
	collision.shape = shape
	add_child(collision)

func _physics_process(_delta: float) -> void:
	var v := move_input
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT): v.x -= 1
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT): v.x += 1
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP): v.y -= 1
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN): v.y += 1
	velocity = v.normalized() * SPEED
	move_and_slide()
	position.x = clampf(position.x, 20, 1780)
	position.y = clampf(position.y, 20, 1080)

func _draw() -> void:
	draw_rect(Rect2(-10, -7, 20, 22), Color("#332c42"))
	draw_rect(Rect2(-8, -17, 16, 14), Color("#d2a17d"))
	draw_rect(Rect2(-9, -20, 18, 7), Color("#17151e"))
	draw_rect(Rect2(-5, -12, 3, 2), Color("#211c28"))
	draw_rect(Rect2(3, -12, 3, 2), Color("#211c28"))
	draw_rect(Rect2(-12, 4, 24, 5), Color("#8e4656"))
	draw_rect(Rect2(-8, 15, 6, 7), Color("#17151e"))
	draw_rect(Rect2(3, 15, 6, 7), Color("#17151e"))
	draw_rect(Rect2(11, -5, 4, 18), Color("#b9b3c5"))
