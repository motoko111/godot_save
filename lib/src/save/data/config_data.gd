extends SaveData
class_name ConfigData

var bgm_volume = 1.0
var se_volume = 1.0
var voice_volume = 1.0
	
func onLoadAfter():
	#SoundManager.getInstance().setBGMVolume(bgm_volume)
	#SoundManager.getInstance().setSEVolume(se_volume)
	#SoundManager.getInstance().setVoiceVolume(voice_volume)
	pass
	
func onSaveBefore():
	#bgm_volume = SoundManager.getInstance().getBGMVolume()
	#se_volume = SoundManager.getInstance().getSEVolume()
	#voice_volume = SoundManager.getInstance().getVoiceVolume()
	pass
