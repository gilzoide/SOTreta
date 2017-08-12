var cols
var lins

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

## Acha quais casas a partir de `inicio` estão dentro do `raio`
# (em distância de Manhattan)
func acha_casas_no_raio(inicio, raio, incluir_inicio=false):
	var res = Vector2Array()
	if incluir_inicio:
		res.append(inicio)
	for i in range(-raio, raio + 1):
		for j in range(-raio, raio + 1):
			var pos = inicio + Vector2(i, j)
			if ta_dentro(pos):
				var dist = distancia_manhattan(inicio, pos)
				if dist > 0 and dist <= raio:
					res.append(pos)
	return res