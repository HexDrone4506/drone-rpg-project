extends Area2D
class_name DamageArea

signal hitteded()

export var damage_amount := 1
export var knockback_strength := 1
export var use_exceptions := false
# FIXME: Keep a reference of the attacker.
export (NodePath) var attacker = null

var exceptions = []

func _ready():
	if attacker != null:
		attacker = get_node_or_null(attacker)

func on_hit(hitbox):
	if use_exceptions:
		exceptions.append(hitbox)
	emit_signal("hitteded")
