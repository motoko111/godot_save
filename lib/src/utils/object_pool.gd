class_name ObjectPool

class ObjectPoolItem:
	var isUse = false
	var obj = null
	func _init(isUse,obj):
		self.isUse = isUse
		self.obj = obj

var items = []
var itemMap = {}
var useItemCount = 0
var onCreate = null
var onDestroy = null
var onUse = null
var onUnUse = null
var checkUse = null

## ObjectPool
## @param initCount 生成数
## @param onCreate 生成処理
## @param onDestroy 削除時の処理
## @param onUse 使用開始時の処理
## @param onUnUse 使用終了時の処理
func _init(initCount, onCreate, onDestroy, onUse = null, onUnUse = null):
	self.onCreate = onCreate
	self.onDestroy = onDestroy
	self.onUse = onUse
	self.onUnUse = onUnUse
	for i in range(0, initCount):
		self.createItem()
		
func createItem():
	var item = ObjectPoolItem.new(false,self.onCreate.call())
	self.items.push_back(item)
	self.itemMap[item.obj] = item

func getItem():
	for item in self.items:
		if !item.isUse:
			item.isUse = true
			if self.onUse:
				self.onUse.call(item.obj)
			useItemCount += 1
			return item.obj
	self.createItem()
	var item = self.items[self.items.size()-1]
	item.isUse = true
	if self.onUse:
		self.onUse.call(item.obj)
	useItemCount += 1
	return item.obj
	
func unused(obj):
	if self.itemMap.has(obj):
		self.itemMap[obj].isUse = false
		if self.onUnUse:
			self.onUnUse.call(obj)
		useItemCount -= 1
		
func apply(f):
	for item in self.items:
		if item.isUse:
			f.call(item.obj)

func clear():
	for item in self.items:
		if self.onDestroy:
			self.onDestroy.call(item.obj)
	self.items.clear()
	useItemCount = 0
