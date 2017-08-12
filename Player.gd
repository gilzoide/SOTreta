## Script de movimento, pros players extenderem
extends KinematicBody2D

export var velocidade = 50.0
export(String) var nome
export(Color, RGB) var cor
export var radius = 10

func _ready():
	assert nome != ""
	set_fixed_process(true)
	set_process(true)

func _process(delta):
	pass

func _fixed_process(delta):
	var inc = Vector2()
	if Input.is_action_pressed(nome + "-up"):
		inc.y = -1
	elif Input.is_action_pressed(nome + "-down"):
		inc.y = 1
	if Input.is_action_pressed(nome + "-left"):
		inc.x = -1
	elif Input.is_action_pressed(nome + "-right"):
		inc.x = 1
	inc = inc.normalized()
	move(inc * delta * velocidade)
