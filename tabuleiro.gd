extends Control

export var cor_linha = Color(0, 1, 0)
export var cor_fundo = Color(0, 0, 0)
export var cor_acao = Color(0, 1, 0, 0.5)

onready var jogo = get_node("/root/jogo")
onready var tamanho = Vector2(jogo.cols * jogo.tamanho_quadrado, jogo.lins * jogo.tamanho_quadrado)
onready var tamanho_quadradim = jogo.tamanho_quadrado - 1
var area_de_acao = null
var area_de_dominio = null
var spawns = {}

func _ready():
	set_size(tamanho)
	set_process_input(true)

## Transforma posição no mundo pra índice no tabuleiro e vice-versa
func pos2idx(pos):
	return (pos / jogo.tamanho_quadrado).floor()
func idx2pos(idx):
	return idx * jogo.tamanho_quadrado

## Setta área onde jogador pode agir
func set_acoes(acoes):
	area_de_acao = acoes
	update()

## Setta área onde os jogadores mantêm domínio
func set_dominio(dominio):
	area_de_dominio = dominio
	update()

## Auxiliar pra criar um Rect2 pra posição específica
func quadradim_rect(pos):
	pos = jogo.idx2pos(pos)
	return Rect2(pos.x, pos.y, tamanho_quadradim, tamanho_quadradim)

# Desenha as linhas 
func _draw():
	draw_rect(Rect2(0, 0, tamanho.x, tamanho.y), cor_fundo)
	if area_de_acao != null:
		for p in area_de_acao:
			draw_rect(quadradim_rect(p), cor_acao)
	if area_de_dominio != null:
		for i in range(jogo.lins):
			for j in range(jogo.cols):
				var d = area_de_dominio[i][j]
				if d > 0:
					draw_rect(quadradim_rect(Vector2(i, j)), jogo.jogadores[0].cor)
				elif d < 0:
					draw_rect(quadradim_rect(Vector2(i, j)), jogo.jogadores[1].cor)
	for i in range(0, tamanho.x + 1, jogo.tamanho_quadrado):
		for j in range(0, tamanho.y + 1, jogo.tamanho_quadrado):
			draw_line(Vector2(i, 0),
			          Vector2(i, tamanho.y),
			          cor_linha)
			draw_line(Vector2(0, j),
			          Vector2(tamanho.x, j),
			          cor_linha)

func _input_event(event):
	if event.type == InputEvent.MOUSE_BUTTON and event.button_mask & BUTTON_MASK_LEFT != 0:
		jogo.clicou(Vector2(event.x, event.y))

## Spawna um objeto do time do `jogador` na posição `idx` (guardada)
func spawna_pro_jogador(jogador, prefab, idx):
	var obj = prefab.instance()
	obj.set_pos(jogo.idx2pos(idx))
	obj.add_to_group(jogador.nome)
	spawns[idx] = obj
	add_child(obj)
	return obj

## Mata um spawn na posição `idx` (se existir)
func mata_spawn(idx):
	if spawns.has(idx):
		var obj = spawns[idx]
		spawns.erase(idx)
		obj.free()

## Get em um spawn que tiver numa posição ae
func get_spawn(idx):
	return spawns[idx] if spawns.has(idx) else null

func novo_jogo():
	for s in spawns.values():
		s.free()
	spawns.clear()
