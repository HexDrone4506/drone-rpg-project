extends Node2D

var characters = []

func _ready():
	Globals.battle_arena = self

func add_character(character : BattleCharacter):
	characters.append(character)
