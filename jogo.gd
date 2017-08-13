extends Node

onready var Utils = get_node("/root/Utils").setup(cols, lins)

export(int) var cols
export(int) var lins
onready var min_quadrados_pra_ganhar = (cols * lins) / 2
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
# Possíveis posições no tabuleiro para uma ação específica
var posicoes_acao = null

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
	var idx_jogador1 = Vector2(randi() % lins, randi() % cols)
	var idx_jogador2 = Vector2(randi() % lins, randi() % cols)
	jogadores[0].set_pos(idx2pos(idx_jogador1))
	jogadores[1].set_pos(idx2pos(idx_jogador2))
	cancela_acao()
	get_node("Tabuleiro").novo_jogo()
	troca_jogador()

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
		for p in Utils.acha_casas_no_raio(pos2idx(o.get_pos()), o.raio):
			tabuleiro[p.x][p.y] += 1
	var time_linux = get_tree().get_nodes_in_group("gnu/linux")
	for o in time_linux:
		for p in Utils.acha_casas_no_raio(pos2idx(o.get_pos()), o.raio):
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
	if qtd_j1 > min_quadrados_pra_ganhar:
		ganhou(jogadores[0])
	elif qtd_j2 > min_quadrados_pra_ganhar:
		ganhou(jogadores[1])
	var qtd_total = float(qtd_j1 + qtd_j2)
	get_node("BGM/jogador1").set_volume(qtd_j1 / qtd_total)
	get_node("BGM/jogador2").set_volume(qtd_j2 / qtd_total)

## Transforma posição no mundo pra índice no tabuleiro e vice-versa
func pos2idx(pos):
	return (pos / tamanho_quadrado).floor()
func idx2pos(idx):
	return idx * tamanho_quadrado

## Roda a máquina de estados, com ações específicas pra cada jogador
var pipe_inicio = null
func clicou(pos):
	var idx = pos2idx(pos)
	if posicoes_acao != null and idx in posicoes_acao:
		if estado == "movendo":
			jogador.set_pos(idx2pos(idx))
		elif estado == "acao1":
			jogador.acao1(idx)
		elif estado == "acao2":
			jogador.acao2(idx)
		elif estado == "acao3":
			if jogador.nome == "win98":
				jogador.acao3(idx, funcref(self, "proximo_turno"))
				return
			else:
				pipe_inicio = idx
				# apaga o índice pra n clicar no mesmo lugar
				for i in range(posicoes_acao.size()):
					if posicoes_acao[i] == idx:
						posicoes_acao.remove(i)
						break
				troca_estado("acao3-pipe")
				return
		elif estado == "acao3-pipe":
			jogador.acao3(pipe_inicio, idx)
			pipe_inicio = null
		proximo_turno()

func proximo_turno():
	troca_jogador()
	cancela_acao()

## Alguém ganhou, YAY!
func ganhou(j):
	get_node("AlguemGanhou").popup(j)

## Sai do jogo
func _on_Sair_pressed():
	get_tree().quit()
## Reinicia o jogo
func _on_Reiniciar_pressed():
	get_node("AlguemGanhou").hide()
	novo_jogo()

#################
##    AÇÕES    ##
#################

## Troca pro estado `e`, settando as posições possíveis (pode ser `null`)
func troca_estado(e):
	estado = e
	get_node("Tabuleiro").set_acoes(posicoes_acao)
## Cancela uma ação, retornando à escolha
func cancela_acao():
	posicoes_acao = null
	troca_estado("escolhe-acao")

## Jogador quer mover
func _on_Mover_pressed():
	if estado != "movendo":  # Selecionou
		posicoes_acao = Utils.acha_casas_no_raio(pos2idx(jogador.get_pos()),
						                         raio_movimento)
		troca_estado("movendo")
	else:
		cancela_acao()

## Jogador quer ação 1
func _on_Acao1_pressed():
	if estado != "acao1":  # Selecionou
		posicoes_acao = jogador.possibilidades_acao1(tabuleiro)
		troca_estado("acao1")
	else:
		cancela_acao()

## Jogador quer ação 2
func _on_Acao2_pressed():
	if estado != "acao2":  # Selecionou
		posicoes_acao = jogador.possibilidades_acao2(tabuleiro)
		troca_estado("acao2")
	else:
		cancela_acao()

## Jogador quer ação 3
func _on_Acao3_pressed():
	if estado != "acao3":  # Selecionou
		posicoes_acao = jogador.possibilidades_acao3(tabuleiro)
		troca_estado("acao3")
	else:
		cancela_acao()
