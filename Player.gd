## Script de movimento, pros players extenderem
extends Node2D

export(String) var nome
export(Color, RGBA) var cor
export var raio = 1
export var acoes = StringArray()

func _ready():
	assert nome != ""
