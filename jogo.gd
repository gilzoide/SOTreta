extends Node

onready var Utils = preload("utils.gd").new().setup(cols, lins)

export(int) var cols
export(int) var lins
export(int) var tamanho_quadrado = 40
export(int) var raio_movimento = 2

var jogador_idx
var jogador
onready var jogadores = [get_node("Tabuleiro/win98"), get_node("Tabuleiro/tux")]
# Tabuleiro de domínio:
#   se positivo: jogador0
#   se negativo: jogador1
#   0: ninguém
var tabuleiro = []
# Estado atual da Máquina de Estados. Para saber mais, veja "maquina-estados.md"
var estado

func _ready():
	randomize()
	novo_jogo()
	
func novo_jogo():
	for i in range(cols):
		tabuleiro.append([])
		for j in range(lins):
			tabuleiro[i].append(0)
	jogador_idx = randi() % 2
	jogadores[0].set_pos(Vector2(0, 0))
	jogadores[1].set_pos(Vector2(tamanho_quadrado * (cols - 1), tamanho_quadrado * (lins - 1)))
	troca_jogador()
	estado = "escolhe-acao"

# Troca a vez, settando as labels que precisar
func troca_jogador():
	jogador_idx = 0 if jogador_idx == 1 else 1
	jogador = jogadores[jogador_idx]
	get_node("HUD/Turno").set_text(jogador.nome)
	get_node("HUD/Acao1").set_text(jogador.acoes[0])
	get_node("HUD/Acao2").set_text(jogador.acoes[1])
	get_node("HUD/Acao3").set_text(jogador.acoes[2])

# Transforma posição no mundo pra índice no tabuleiro e vice-versa
func pos2idx(pos):
	return (pos / tamanho_quadrado).floor()
func idx2pos(idx):
	return idx * tamanho_quadrado

# Roda a máquina de estados, com ações específicas pra cada jogador
func clicou(pos):
	pos = pos2idx(pos)
	print("Clique em", pos, "; ", estado)
	if estado == "movendo":
		var pos_jogador = pos2idx(jogador.get_pos())
		var distancia = Utils.distancia_manhattan(pos, pos_jogador)
		print(pos, pos_jogador, distancia)
		if distancia > 0 and distancia <= raio_movimento:
			jogador.set_pos(idx2pos(pos))
			troca_jogador()
		estado = "escolhe-acao"
		get_node("Tabuleiro").set_acoes(null)


func _on_Mover_pressed():
	if estado == "escolhe-acao":
		get_node("Tabuleiro").set_acoes(Utils.acha_casas_no_raio(pos2idx(jogador.get_pos()), raio_movimento))
		estado = "movendo"
