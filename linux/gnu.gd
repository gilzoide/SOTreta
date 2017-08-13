extends Node2D

export(int) var raio = 0
export(bool) var acordado = false

func _ready():
	acorda(acordado)

func acorda(b):
	acordado = b
	if b:
		raio = 1
		set_opacity(1.0)
		get_node("pipe_num").set_text(str(pipe.size()))
	else:
		raio = 0
		set_opacity(0.3)

##########
## Pipe ##
##########
export var pipe = []

func add_pipe(para):
	pipe.append(para)
	raio += 1
	get_node("pipe_num").set_text(str(pipe.size()))
