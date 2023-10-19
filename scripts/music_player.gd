extends Node

var current_song = "world"
var currently_fading = false

func play_song(newsong):
	if current_song != newsong and currently_fading == false:
		_fade_out(current_song)
	if newsong == "world":
		$SongWorld.play()
		$SongWorld.volume_db = 0
	elif newsong == "level_1":
		$SongLevel1.play()
		$SongLevel1.volume_db = 0
	elif newsong == "level_2":
		$SongLevel2.play()
		$SongLevel2.volume_db = -5
	elif newsong == "level_3":
		$SongLevel3.play(6.0)
		$SongLevel3.volume_db = 0
	elif newsong == "level_4":
		$SongLevel4.play()
		$SongLevel4.volume_db = 0
	elif newsong == "level_final_boss":
		$SongFinalBoss.play(10.5)
		var wait = 0.05
		var start_volume = -40
		for n in range(start_volume, 0):
			$SongFinalBoss.volume_db = n
			await get_tree().create_timer(wait).timeout
		$SongFinalBoss.volume_db = 0
	current_song = newsong

func _fade_out(song):
	if currently_fading == false:
		currently_fading = true
		var song_to_fade
		var wait = 0.05
		var start_volume = 0
		if song == "world":
			song_to_fade = $SongWorld
		elif song == "level_1":
			song_to_fade = $SongLevel1
		elif song == "level_2":
			song_to_fade = $SongLevel2
			start_volume = -5
		elif song == "level_3":
			song_to_fade = $SongLevel3
		elif song == "level_4":
			song_to_fade = $SongLevel4
		elif song == "level_final_boss":
			song_to_fade = $SongFinalBoss
		for n in range(start_volume,-40, -1):
			song_to_fade.volume_db = n
			await get_tree().create_timer(wait).timeout
		if song != current_song:
			song_to_fade.playing = false
		currently_fading = false
