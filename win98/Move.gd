## Script de movimento, pros players extenderem
extends Node2D

func _ready():
	self.nome = get_node(".").get_name()
	print(self.nome)
	set_fixed_process(true)

func _fixed_process(delta):
	pass
