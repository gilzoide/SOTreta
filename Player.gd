## Script de movimento, pros players extenderem
extends Node2D

export var velocidade = 50.0
export(String) var nome
export(Color, RGB) var cor
export var radius = 10

func _ready():
	assert nome != ""
