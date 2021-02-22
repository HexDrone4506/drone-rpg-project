extends KinematicBody2D
class_name BattleCharacter

const KNOCKBACK_VELOCITY = 350

enum Factions { ALLY, ENEMY }

onready var attack_cooldown = $Timers/AttackCooldown
onready var damage_animator = $DamageAnimator
onready var hitbox = $HitBox

export var move_speed_units := 8.0
export var max_health := 5
export (Factions) var faction = 0
export var knockback_modifier = 1.0

onready var health := max_health setget set_health

var target_ref = null setget set_target, get_target

var velocity := Vector2()
var move_input := Vector2()

## Functions

func knockback(knockback_strength, source_position):
	var normal = (global_position - source_position).normalized()
	if knockback_modifier != 0:
		velocity = knockback_strength * normal * KNOCKBACK_VELOCITY

func _apply_movement():
	velocity = move_and_slide(velocity)

func move_towards(to):
	var displacement = to - global_position
	var normal = displacement.normalized()
	velocity = lerp(velocity, normal * move_speed_units * 24, get_move_weight())

func get_move_weight():
	return 0.3

func get_ideal_target():
	var nearest_target = null
	var distance = INF
	for character in Globals.battle_arena.characters.get_children():
		if character.faction == Factions.ALLY:
			var this_distance = (character.global_position - global_position).length()
			if this_distance < distance:
				nearest_target = character
				distance = this_distance
	if nearest_target != null:
		return nearest_target

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
	if damage_source != null:
		knockback(knockback_strength, damage_source.global_position)
	damage_animator.play("damage")
	if hitbox.immunity_duration != 0:
		damage_animator.queue("invulnerability")

func _on_HitBox_immunity_ended():
	damage_animator.play("reset")
