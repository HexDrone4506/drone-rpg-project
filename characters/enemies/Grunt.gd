extends Enemy
class_name Grunt

func _physics_process(delta):
	var target = get_target()
	if target == null:
		target = get_ideal_target()
	if target != null:
		move_towards(target.global_position)
	
	_apply_movement()
