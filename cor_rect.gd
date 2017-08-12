extends Control

export(Color) var cor

func _draw():
	draw_rect(Rect2(Vector2(0, 0), get_size()), cor)