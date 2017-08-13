extends "../Player.gd"

const Gnu = preload("res://linux/gnu.tscn")
const Pipe = preload("res://linux/pipe.tscn")

## Fork: só onde tem domínio
func possibilidades_acao1(tabuleiro):
	return Utils.acha_dominio_do_jogador(self, tabuleiro, funcref(self, "nao_tem_spawn"))
## Exec: só onde tem processos dormindo
func ta_dormindo(o):
	return not o.acordado
func possibilidades_acao2(tabuleiro):
	return get_spawn_indices(funcref(self, "ta_dormindo"))
## Pipe: só onde tem processos acordados, máximo de 2 pipes por processo
func pode_pipear(o):
	return o.acordado and o.pipe.size() < 2
func possibilidades_acao3(tabuleiro):
	var res = get_spawn_indices(funcref(self, "pode_pipear"))
	return res if res.size() > 1 else null

## Fork: gera um processo Gnu
func acao1(idx):
	Tabuleiro.spawna_pro_jogador(self, Gnu, idx)
## Exec: acorda um processo Gnu dormente
func acao2(idx):
	Tabuleiro.get_spawn(idx).acorda(true)
## Pipe: liga dois processos Gnu, aumentando seu raio
func meio_quadrado(pos):
	return Tabuleiro.idx2pos(Tabuleiro.pos2idx(pos) + Vector2(0.5, 0.5))
func acao3(de, para):
	de = Tabuleiro.get_spawn(de)
	para = Tabuleiro.get_spawn(para)
	de.add_pipe(para)
	para.add_pipe(de)
	var novo_pipe = Pipe.instance()
	novo_pipe.setup(de.get_global_pos(), para.get_global_pos())
	de.add_child(novo_pipe)
