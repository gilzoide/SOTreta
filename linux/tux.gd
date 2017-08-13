extends "../Player.gd"

onready var Gnu = preload("res://linux/gnu.tscn")


## Fork: só onde tem domínio
func possibilidades_acao1(tabuleiro):
	return Utils.acha_dominio_do_jogador(self, tabuleiro, funcref(self, "nao_tem_spawn"))
## Exec: só onde tem processos dormindo
func ta_dormindo(o):
	return not o.acordado
func possibilidades_acao2(tabuleiro):
	return get_spawn_indices(funcref(self, "ta_dormindo"))
## Pipe: só onde tem processos acordado
func ta_acordado(o):
	return o.acordado
func possibilidades_acao3(tabuleiro):
	var res = get_spawn_indices(funcref(self, "ta_acordado"))
	return res if res.size() > 1 else null

## Fork: gera um processo Gnu
func acao1(idx):
	Tabuleiro.spawna_pro_jogador(self, Gnu, idx)
## Exec: acorda um processo Gnu dormente
func acao2(idx):
	Tabuleiro.get_spawn(idx).acorda(true)
## Pipe: liga dois processos Gnu, aumentando seu raio
func acao3(de, para):
	print(de, para)

