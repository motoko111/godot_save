extends SaveData
class_name SystemData

var last_save_index = 0
var config_data = ConfigData.new()
			
func onLoadBefore():
	pass

func onLoadAfter():
	config_data.onLoadAfter()
	
func onSaveBefore():
	config_data.onSaveBefore()
	
func onSaveAfter():
	pass
