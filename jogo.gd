extends Node2D

const cor_linha = Color(0, 1, 0)
const divide_por = 40
var cols
var lins

func _ready():
	var tamanho = get_viewport_rect().size
	lins = tamanho.y / divide_por
	cols = tamanho.x / divide_por

# Desenha as linhas 
func _draw():
	var tamanho = get_viewport_rect().size
	for i in range(cols):
		for j in range(lins):
			draw_line(Vector2(i * divide_por, 0), Vector2(i * divide_por, tamanho.y), cor_linha)
			draw_line(Vector2(0, j * divide_por), Vector2(tamanho.x, j * divide_por), cor_linha)
