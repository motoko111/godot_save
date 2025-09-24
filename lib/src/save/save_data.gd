class_name SaveData

## ===================================================
## SaveDataのベースクラス
## ===================================================

static var REGEX_IGNORE_PROPERTY:RegEx = RegEx.create_from_string("(^RefCounted$|^script$|.*\\.gd$|^Built-in script$)")
const PREFIX_SAVEDATA_PROPERTY = "@data"

var version = 1

func getVersion():
	return 1
	
func getDataName():
	return get_script().resource_path.get_file()
	
func toJsonData() -> Dictionary:
	# 保存するときにバージョンを設定する
	self.version = getVersion()
	
	var data = {}
	var props = get_property_list()
	for prop in props:
		if !_checkIgnoreProperty(prop.name):
			var v = get(prop.name)
			if v != null and v is SaveData:
				data[PREFIX_SAVEDATA_PROPERTY + "|" + prop.name] = v.toJsonData()
			elif v != null and v is Dictionary:
				data[prop.name] = v
			elif v != null and v is Array:
				data[prop.name] = v
			else:
				data[prop.name] = v
	return data
	
func _toJsonData(data,prop_name,v):
	if v != null:
		if v is SaveData:
			data[PREFIX_SAVEDATA_PROPERTY + "|" + prop_name] = v.toJsonData()
		elif v is Dictionary:
			data[prop_name] = v
		elif v is Array:
			var arr = []
			for av in v:
				arr.push_back(toJsonData())
			data[prop_name] = v
		else:
			data[prop_name] = v
	
func fromJsonData(data:Dictionary):
	# バージョンが上がっていたらバージョンアップ処理
	if data.has("version"):
		if data["version"] < version:
			onVersionUp(data)
			
	for prop:String in data.keys():
		var v = data[prop]
		if v != null and v is Dictionary:
			if PREFIX_SAVEDATA_PROPERTY in prop:
				var strs = prop.split("|")
				var p = strs[1]
				get(p).fromJsonData(v)
			else:
				set(prop, v)
		else:
			set(prop, v)
			
func onVersionUp(data:Dictionary):
	pass
			
func parseDictionaryProperty(prop:String,v:Dictionary):
	return v
	
func toJson() -> String:
	return JSON.stringify(toJsonData())
	
func fromJson(json:String):
	var data = JSON.parse_string(json)
	self.fromJsonData(data)
	
func _checkIgnoreProperty(propName):
	return REGEX_IGNORE_PROPERTY.search(propName)

## Load前処理
func onLoadBefore():
	pass

## Load後処理
func onLoadAfter():
	pass
	
## Save前処理
func onSaveBefore():
	pass
	
## Save後処理
func onSaveAfter():
	pass
