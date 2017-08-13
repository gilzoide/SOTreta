extends Sprite

export(int) var raio = 0
export(bool) var acordado

func _ready():
	acorda(acordado)

func acorda(b):
	acordado = b
	if b:
		raio = 1
		set_opacity(1.0)
	else:
		raio = 0
		set_opacity(0.3)
