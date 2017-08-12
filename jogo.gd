extends Node

onready var Utils = preload("utils.gd").new().setup(cols, lins)

export(int) var cols
export(int) var lins
onready var num_quadrados = cols * lins
export(int) var tamanho_quadrado = 40
export(int) var raio_movimento = 2

var jogador_idx
var jogador
export(Array) var jogadores
# Tabuleiro de domínio:
#   se positivo: jogador0
#   se negativo: jogador1
#   0: ninguém
var tabuleiro
# Estado atual da Máquina de Estados. Para saber mais, veja "maquina-estados.md"
var estado

func _ready():
	randomize()
	jogadores = [get_node("Tabuleiro/win98"), get_node("Tabuleiro/tux")]
	jogadores[0].add_to_group(jogadores[0].nome)
	jogadores[1].add_to_group(jogadores[1].nome)
	get_node("HUD/Dominio/Jogador1/Cor").set_frame_color(jogadores[0].cor)
	get_node("HUD/Dominio/Jogador2/Cor").set_frame_color(jogadores[1].cor)
	novo_jogo()
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("mover"):
		get_node("HUD/BotoesAcao/Mover").emit_signal("pressed")
	elif event.is_action_pressed("acao1"):
		get_node("HUD/BotoesAcao/Acao1").emit_signal("pressed")
	elif event.is_action_pressed("acao2"):
		get_node("HUD/BotoesAcao/Acao2").emit_signal("pressed")
	elif event.is_action_pressed("acao3"):
		get_node("HUD/BotoesAcao/Acao3").emit_signal("pressed")

## Resetta o tabuleiro
func reset_tabuleiro():
	for i in range(cols):
		for j in range(lins):
			tabuleiro[i][j] = 0

## Resetta o jogo
func novo_jogo():
	tabuleiro = []
	for i in range(cols):
		tabuleiro.append([])
		for j in range(lins):
			tabuleiro[i].append(0)
	jogador_idx = randi() % 2
	jogadores[0].set_pos(Vector2(0, 0))
	jogadores[1].set_pos(Vector2(tamanho_quadrado * (cols - 1), tamanho_quadrado * (lins - 1)))
	troca_jogador()
	estado = "escolhe-acao"

## Troca a vez, settando as labels que precisar
func troca_jogador():
	jogador_idx = 0 if jogador_idx == 1 else 1
	jogador = jogadores[jogador_idx]
	get_node("HUD/Turno/Valor").set_text(jogador.nome)
	get_node("HUD/BotoesAcao/Acao1").set_text("2. " + jogador.acoes[0])
	get_node("HUD/BotoesAcao/Acao2").set_text("3. " + jogador.acoes[1])
	get_node("HUD/BotoesAcao/Acao3").set_text("4. " + jogador.acoes[2])
	reset_tabuleiro()
	calcula_dominio()

## Calcula o domínio pelo tabuleiro
func calcula_dominio():
	var time_win98 = get_tree().get_nodes_in_group("win98")
	for o in time_win98:
		for p in Utils.acha_casas_no_raio(pos2idx(o.get_pos()), o.raio, true):
			tabuleiro[p.x][p.y] += 1
	var time_linux = get_tree().get_nodes_in_group("gnu/linux")
	for o in time_linux:
		for p in Utils.acha_casas_no_raio(pos2idx(o.get_pos()), o.raio, true):
			tabuleiro[p.x][p.y] -= 1
	get_node("Tabuleiro").set_dominio(tabuleiro)
	# calcula quantos quadradinhos estão dominados por cada time
	# e põe na HUD
	var qtd_j1 = 0
	var qtd_j2 = 0
	for r in tabuleiro:
		for c in r:
			if c > 0:
				qtd_j1 += 1
			elif c < 0:
				qtd_j2 += 1
	get_node("HUD/Dominio/Jogador1/Valor").set_text(str(qtd_j1))
	get_node("HUD/Dominio/Jogador2/Valor").set_text(str(qtd_j2))
	if qtd_j1 > num_quadrados:
		ganhou(jogadores[0])
	elif qtd_j2 > num_quadrados:
		ganhou(jogadores[1])

## Transforma posição no mundo pra índice no tabuleiro e vice-versa
func pos2idx(pos):
	return (pos / tamanho_quadrado).floor()
func idx2pos(idx):
	return idx * tamanho_quadrado

## Roda a máquina de estados, com ações específicas pra cada jogador
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

## Alguém ganhou, YAY!
func ganhou(j):
	get_node("AlguemGanhou").popup(j)

## Jogador quer mover
func _on_Mover_pressed():
	if estado == "escolhe-acao":  # Selecionou
		get_node("Tabuleiro").set_acoes(Utils.acha_casas_no_raio(pos2idx(jogador.get_pos()), raio_movimento))
		estado = "movendo"
	elif estado == "movendo":  # Cancelou
		estado = "escolhe-acao"
		get_node("Tabuleiro").set_acoes(null)

func _on_Sair_pressed():
	get_tree().quit()

func _on_Reiniciar_pressed():
	get_node("AlguemGanhou").hide()
	novo_jogo()
