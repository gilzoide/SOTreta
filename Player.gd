## Script de movimento, pros players extenderem
extends Node2D

export(String) var nome
export(Color, RGB) var cor
export var radius = 2
export var acoes = StringArray()

func _ready():
	assert nome != ""
