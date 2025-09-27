extends Node
class_name SaveTest

@export var window:Control = null
@export var textEdit:TextEdit = null

func _ready() -> void:
	for child in window.get_children():
		child.queue_free()
	var s_mger = SaveDataManager.getInstance()
	button("save", func(): s_mger.saveData("test_data", textEdit.text))
	button("load", func(): textEdit.text = s_mger.loadData("test_data"))
	button("delete", func(): s_mger.deleteData("test_data"))
	
	button("save user_data", func(): s_mger.getUserDataAccess().saveCurrentData(0))
	button("load user_data", func(): 
		s_mger.getUserDataAccess().loadCurrentData(0)
		var user_data:UserData = s_mger.getUserDataAccess().getCurrentData()
		print(str(user_data.toJson()))
		)
		
	button("save system_data", func(): s_mger.getSystemDataAccess().saveCurrentData(0))
	button("load system_data", func(): 
		s_mger.getSystemDataAccess().loadCurrentData(0)
		var system_data:SystemData = s_mger.getSystemDataAccess().getCurrentData()
		print(str(system_data.toJson()))
		)
	
	var data = SystemData.new()
	print(str(data.toJson()))
	s_mger.saveData("save_data", data.toJson())
	var json = s_mger.loadData("save_data")
	textEdit.text = json
	var data2 = SystemData.new()
	data2.fromJson(json)
	print(str(data2.toJson()))
	
func button(label,onclicked):
	var btn = Button.new()
	btn.size = Vector2(100,100)
	btn.text = label
	window.add_child(btn)
	btn.connect("pressed",onclicked)

func slider(label, default, min, max, onChanged):
	var s = HSlider.new()
	s.value = default
	s.min_value = min
	s.max_value = max
	s.step = 0.01
	window.add_child(s)
	s.connect("value_changed",onChanged)
