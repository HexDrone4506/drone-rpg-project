extends Node2D

var characters = []

func _ready():
	Globals.battle_arena = self

func add_character(character : Character):
	characters.append(character)
