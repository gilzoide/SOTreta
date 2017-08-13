extends Sprite

var vetor
var fim
var fator = 0

func _ready():
	set_process(true)

func setup(de, para, idx_alvo):
	set_pos(de)
	set_rot(de.angle_to_point(para))
	vetor = para - de
	fim = idx_alvo

func _process(delta):
	if fator >= 1.0:
		queue_free()
		get_parent().mata_spawn(fim)
	else:
		translate(vetor * delta)
		fator += delta

