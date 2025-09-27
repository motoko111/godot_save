class_name SaveData

## ===================================================
## SaveDataのベースクラス
## ArrayやDictionaryのプロパティは型を設定していると読み込みに失敗するので注意.
## ===================================================

## 保存対象から除外するプロパティ
static var REGEX_IGNORE_PROPERTY:RegEx = RegEx.create_from_string("(^RefCounted$|^script$|.*\\.gd$|^Built-in script$|^_.*$)")
## DictionaryにこのKeyがあった場合値をSaveData継承クラスとして扱う
const PARSE_SAVEDATA_KEY = "@data" 

var version = 1

static var _parse_error:bool = false ## エラーがあったか

func getVersion():
	return 1
	
func getDataName():
	return get_script().resource_path.get_file()
	
## このクラスのデータをDictionaryに変換
func toJsonData() -> Dictionary:
	# 保存するときにバージョンを設定する
	self.version = getVersion()
	
	var data = {}
	# SaveData継承であることをkeyで判断する
	data[PARSE_SAVEDATA_KEY] = getDataName()
	var props = get_property_list()
	for prop in props:
		if !_checkIgnoreProperty(prop.name):
			var v = get(prop.name)
			data[prop.name] = _toJsonData(v)
	return data
	
func _toJsonData(v):
	if v != null:
		if v is SaveData:
			return v.toJsonData()
		elif v is Dictionary:
			var dic = {}
			for key in v.keys():
				var vv = v[key]
				dic[key] = _toJsonData(vv)
			return dic
		elif v is Array:
			var arr = []
			for vv in v:
				arr.push_back(_toJsonData(vv))
			return arr
		else:
			return v
	return null
	
func fromJsonData(data:Dictionary):
	# バージョンが上がっていたらバージョンアップ処理
	if data.has("version"):
		if data["version"] < version:
			onVersionUp(data)
			
	for prop:String in data.keys():
		var v = data[prop]
		var vv = _fromJsonData(v)
		set(prop, vv)
		if vv is Array or vv is Dictionary:
			# 読み込みに失敗している
			if get(prop).size() != vv.size():
				SaveData._parse_error = true
				assert(false, "[SaveData::fromJsonData] %s %s のデータ読み込みに失敗しています. ArrayまたはDictionaryのサイズが一致しません. [%d != %d]" % [getDataName(), prop, get(prop).size(), vv.size()])
			
func _fromJsonData(v):
	if v is Dictionary:
		if v.has(PARSE_SAVEDATA_KEY):
			var file_name = v[PARSE_SAVEDATA_KEY]
			var vv = ObjectUtils.create_instance_by_file_name(file_name)
			vv.fromJsonData(v)
			return vv
		else:
			var dic = {}
			for key in v.keys():
				var vv = v[key]
				dic[key] = _fromJsonData(vv)
			return dic
	elif v is Array:
		var arr = []
		for vv in v:
			arr.push_back(_fromJsonData(vv))
		return arr
	else:
		return v
			
func onVersionUp(data:Dictionary):
	pass
			
func parseDictionaryProperty(prop:String,v:Dictionary):
	return v
	
func toJson() -> String:
	return JSON.stringify(toJsonData())
	
func fromJson(json:String) -> bool:
	SaveData._parse_error = false
	var data = JSON.parse_string(json)
	self.fromJsonData(data)
	return !SaveData._parse_error
	
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
