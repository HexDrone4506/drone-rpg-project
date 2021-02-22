extends Character
class_name PlayableCharacter

const HAND_RADIUS := 24

func _unhandled_input(event):
	if event.is_action_pressed("attack") and attack_cooldown.is_stopped():
		attack()

func _physics_process(delta):
	move_input.x = -Input.get_action_strength("move_left") + Input.get_action_strength("move_right")
	move_input.y = -Input.get_action_strength("move_up") + Input.get_action_strength("move_down")
	move_input = move_input.normalized()
	
	velocity = move_input * move_speed_units * 24
	
	velocity = move_and_slide(velocity)

func attack():
	attack_cooldown.start()
	var attack_area = preload("res://attack/AttackArea.tscn").instance()
	add_child(attack_area)
	var mouse = get_global_mouse_position() - global_position
	attack_area.position = mouse.normalized() * HAND_RADIUS
