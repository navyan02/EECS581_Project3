extends Node2D

var lines := []
var previewing := false
var preview_start: Vector2
var preview_end: Vector2

func _process(_delta):
	if previewing:
		preview_end = get_global_mouse_position()
		queue_redraw()

func _draw():
	for line in lines:
		draw_line(line[0], line[1], Color(1.0, 1.0, 1.0, 1.0), 4) # red lines

	if previewing:
		draw_line(preview_start, preview_end, Color(1,1,0), 2) # yellow preview

func start_preview(pos: Vector2):
	preview_start = pos
	previewing = true

func finish_preview(end_pos: Vector2):
	lines.append([preview_start, end_pos])
	previewing = false
	queue_redraw()

func cancel_preview():
	previewing = false
	queue_redraw()

func reset():
	lines.clear()
	previewing = false
	queue_redraw()
