extends KinematicBody2D
class_name BattleCharacter

enum Factions { ALLY, ENEMY }

onready var attack_cooldown = $Timers/AttackCooldown
onready var damage_animator = $DamageAnimator
onready var hitbox = $HitBox

export var move_speed_units := 8.0
export var max_health := 100
export (Factions) var faction = 0

onready var health := max_health setget set_health

var target_ref = null setget set_target, get_target

var velocity := Vector2()
var move_input := Vector2()

## Functions

func _ready():
	yield()
	Globals.battle_arena.add_character(self)

# The idea of get_target and set_target this is to enforce that characters store
# weak references to their targets. This is so as if a character is yeeted out
# of existence and released, no other character targeting them is holding up any
# freeing of resources.

func set_target(value):
	if value is WeakRef:
		target_ref = value
	else:
		target_ref = weakref(value) 

func get_target():
	var target = null
	if target_ref is WeakRef:
		target = target_ref.get_ref()
	return target

func set_health(value):
	health = clamp(value, 0, max_health)
	if health <= 0:
		die()

func die():
	queue_free()


## Signals
func _on_HitBox_damaged(amount, knockback_strength, damage_source, attacker):
	set_health(health - amount)
	damage_animator.play("damage")
	if hitbox.immunity_duration != 0:
		damage_animator.queue("invulnerability")

func _on_HitBox_immunity_ended():
	damage_animator.play("reset")
