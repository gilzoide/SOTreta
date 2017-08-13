## Script de movimento, pros players extenderem
extends Node2D

onready var Utils = get_node("/root/Utils")

export(String) var nome
export(Color, RGBA) var cor
export var raio = 1
export var acoes = StringArray()
export(NodePath) var caminho_tabuleiro
onready var Tabuleiro = get_node(caminho_tabuleiro)

func _ready():
	assert nome != ""

## Pega todos os índices dos spawns
func get_spawn_indices(filtro=Utils.vdd):
	var res = Vector2Array()
	for o in get_tree().get_nodes_in_group(nome):
		if o != self and filtro.call_func(o):
			res.append(Tabuleiro.pos2idx(o.get_pos()))
	return res

## Tem algum spawn na posição `idx` do tabuleiro?
func tem_spawn(idx):
	return Tabuleiro.get_spawn(idx) != null
## NOT Tem algum spawn na posição `idx` do tabuleiro?
func nao_tem_spawn(idx):
	return Tabuleiro.get_spawn(idx) == null
