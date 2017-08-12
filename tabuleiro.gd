extends Control

const cor_linha = Color(0, 1, 0)
const cor_fundo = Color(0, 0, 0)
const cor_acao = Color(1, 1, 0)

onready var jogo = get_node("/root/jogo")
onready var tamanho = Vector2(jogo.cols * jogo.tamanho_quadrado, jogo.lins * jogo.tamanho_quadrado)
onready var tamanho_quadrado_acao = jogo.tamanho_quadrado - 1
var area_de_acao = null

func _ready():
	set_size(tamanho)
	set_process_input(true)

func set_acoes(acoes):
	area_de_acao = acoes
	update()

func quadrado_acao_rect(pos):
	return Rect2(pos.x, pos.y, tamanho_quadrado_acao, tamanho_quadrado_acao)

# Desenha as linhas 
func _draw():
	draw_rect(Rect2(0, 0, tamanho.x, tamanho.y), cor_fundo)
	if area_de_acao != null:
		for p in area_de_acao:
			draw_rect(quadrado_acao_rect(jogo.idx2pos(p)), cor_acao)
	for i in range(0, tamanho.x + 1, jogo.tamanho_quadrado):
		for j in range(0, tamanho.y + 1, jogo.tamanho_quadrado):
			draw_line(Vector2(i, 0),
			          Vector2(i, tamanho.y),
			          cor_linha)
			draw_line(Vector2(0, j),
			          Vector2(tamanho.x, j),
			          cor_linha)

func _input_event(event):
	if event.type == InputEvent.MOUSE_BUTTON and event.is_pressed():
		jogo.clicou(Vector2(event.x, event.y))
