extends Sprite

var vetor
var fim
var callback
var fator = 0

func _ready():
	set_process(true)

func setup(de, para, idx_alvo, cb):
	translate(de)
	set_rot(de.angle_to_point(para))
	vetor = para - de
	fim = idx_alvo
	callback = cb

func _process(delta):
	if fator >= 1.0:
		get_parent().mata_spawn(fim)
		queue_free()
		callback.call_func()
	else:
		translate(vetor * delta)
		fator += delta

