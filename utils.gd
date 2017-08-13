extends Node

export(int) var cols
export(int) var lins

func setup(cols, lins):
	self.cols = cols
	self.lins = lins
	return self

## Acha a distância de Manhattan entre dois Vector2
func distancia_manhattan(pos1, pos2):
	return abs(pos1.x - pos2.x) + abs(pos1.y - pos2.y)

## Verifica se uma posição tá dentro do tabuleiro
func ta_dentro(pos):
	return pos.x >= 0 and pos.x < cols and pos.y >= 0 and pos.y < lins

## Filtro padrão: sempre verdade
func verdade(x):
	return true
onready var vdd = funcref(self, "verdade")

## Acha quais casas a partir de `inicio` estão dentro do `raio`
# (em distância de Manhattan)
func acha_casas_no_raio(inicio, raio, filtro=vdd):
	var res = Vector2Array()
	for i in range(-raio, raio + 1):
		for j in range(-raio, raio + 1):
			var idx = inicio + Vector2(i, j)
			if ta_dentro(idx):
				var dist = distancia_manhattan(inicio, idx)
				if dist <= raio and filtro.call_func(idx):
					res.append(idx)
	return res

## Acha quais casas são dominadas pelo jogador `jogador`
# Passe `null` pra achar casas não dominadas
func acha_dominio_do_jogador(jogador, tabuleiro, filtro=vdd):
	var res = Vector2Array()
	for i in range(lins):
		for j in range(cols):
			if jogador == null and tabuleiro[i][j] == 0 or \
			   jogador != null and (jogador.nome == "win98" and tabuleiro[i][j] > 0 or \
			                        jogador.nome == "gnu/linux" and tabuleiro[i][j] < 0):
				var pos = Vector2(i, j)
				if filtro.call_func(pos):
					res.append(pos)
	return res
