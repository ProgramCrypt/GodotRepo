extends Control


func _ready():
	$music/Uranus.play()


func newRandomMusic():
	var tracks = []
	for child in $music.get_children():
		if child is AudioStreamPlayer:
			tracks.append(child)
	var track = tracks.pick_random()
	track.play()


func randomizeTimer(timer, average, deviation):
	var time = average + randi_range(-deviation, deviation)
	timer.wait_time = time
	timer.start()


func _on_music_timer_timeout():
	newRandomMusic()


func _on_uranus_finished():
	randomizeTimer($music/musicTimer, 60, 20)


func _on_neptune_finished():
	randomizeTimer($music/musicTimer, 60, 20)
