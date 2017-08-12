extends Node

export(int) var cols
export(int) var lins
export(int) var tamanho_quadrado = 40

var jogador_idx
var jogador
onready var jogadores = [get_node("Tabuleiro/win98"), get_node("Tabuleiro/tux")]

func _ready():
	randomize()
	jogador_idx = randi() % 2
	jogadores[0].set_pos(Vector2(0, 0))
	jogadores[1].set_pos(Vector2(tamanho_quadrado * (cols - 1), tamanho_quadrado * (lins - 1)))
	troca_jogador()

func troca_jogador():
	jogador_idx = 0 if jogador_idx == 1 else 1
	jogador = jogadores[jogador_idx]
	get_node("HUD/Turno").set_text(jogador.get_name())
