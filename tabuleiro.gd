extends Node2D

const cor_linha = Color(0, 1, 0)

onready var jogo = get_node("/root/jogo")

# Desenha as linhas 
func _draw():
	var x_max = jogo.cols * jogo.tamanho_quadrado
	var y_max = jogo.lins * jogo.tamanho_quadrado
	for i in range(jogo.cols + 1):
		for j in range(jogo.lins + 1):
			draw_line(Vector2(i * jogo.tamanho_quadrado, 0),
			          Vector2(i * jogo.tamanho_quadrado, y_max),
			          cor_linha)
			draw_line(Vector2(0, j * jogo.tamanho_quadrado),
			          Vector2(x_max, j * jogo.tamanho_quadrado),
			          cor_linha)
