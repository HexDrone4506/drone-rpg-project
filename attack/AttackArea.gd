extends Node2D
class_name AttackArea

onready var damage_area = $DamageArea

func set_attacker(attacker):
	damage_area.attacker = attacker

func _on_Timer_timeout():
	# TODO: Animation
	queue_free()
