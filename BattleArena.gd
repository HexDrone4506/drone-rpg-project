extends Node2D

onready var characters = $Characters

func _ready():
	Globals.battle_arena = self

func add_character(character : BattleCharacter):
	characters.append(character)
