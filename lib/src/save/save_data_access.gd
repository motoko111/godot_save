class_name SaveDataAccess

var cls = null
var file_format:String = ""
var last_access_index = 0
var current_data = null
var isUseIndex = false

func _init(_cls,_file_format) -> void:
	self.cls = _cls
	self.file_format = _file_format
	self.current_data = self.cls.new()
	
func getDataPath(index):
	return self.file_format % [index]
	
func getLastAccessIndex() -> int:
	return last_access_index
	
func loadCurrentData(index, isEvent = true, isAutoCreate = true):
	var data = loadData(index,isEvent)
	if !data and isAutoCreate:
		data = self.cls.new()
	setCurrentData(data)
	
func saveCurrentData(index, isEvent = true):
	return saveData(index,getCurrentData(),isEvent)
	
func loadData(index, isEvent = true):
	last_access_index = index
	var data_str = SaveDataManager.getInstance().loadData(getDataPath(index))
	if data_str.is_empty():
		return null
	var data = self.cls.new()
	if isEvent:
		data.onLoadBefore()
	data.fromJson(data_str)
	if isEvent:
		data.onLoadAfter()
	return data
	
func saveData(index,data, isEvent = true) -> bool:
	last_access_index = index
	if isEvent:
		data.onSaveBefore()
	var success = SaveDataManager.getInstance().saveData(getDataPath(index), data.toJson())
	if isEvent:
		data.onSaveAfter()
	return success
	
func deleteData(index) -> bool:
	return SaveDataManager.getInstance().deleteData(getDataPath(index))
		
func setCurrentData(data):
	current_data = data
	
func getCurrentData():
	return current_data
