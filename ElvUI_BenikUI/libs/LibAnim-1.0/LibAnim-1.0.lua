local LibAnim = {}
LibAnim.Types = {}
LibAnim.Callbacks = {}
LibAnim.GroupCallbacks = {}

function LibAnim:NewType(type, func)
	if self.Types[type] then
		return
	end
	
	self.Types[type] = func
	self.Callbacks[type] = {}
end

local Run = function(object, type, ...)
	if (not LibAnim.Types[type]) then
		return
	end
	
	LibAnim.Types[type](object, ...)
end

local OnFinished = function(self, type, func)
	if (not LibAnim.Callbacks[type] or LibAnim.Callbacks[type][self]) then
		return
	end
	
	LibAnim.Callbacks[type][self] = func
end

function LibAnim:Callback(object, type, ...)
	if (not self.Callbacks[type][object]) then
		return
	end
	
	self.Callbacks[type][object](object, ...)
end

function LibAnim:GroupCallback(object)
	if (not object._Group) then
		return
	end
	
	object._Group.LastIndex = object._Group.LastIndex + 1
	
	if (object._Group.LastIndex > #object._Group.Queue) then
		object._Group.LastIndex = 1 -- Reset the order
		object._Group.TimesRun = object._Group.TimesRun + 1 -- The whole group finished, add a tick
		
		if (not object._Group.Looping or (object._Group.NumLoops and object._Group.TimesRun >= object._Group.NumLoops) or object._Group.Finish) then
			object._Group.TimesRun = 0
			
			return
		end
	end
	
	object:Run(unpack(object._Group.Queue[object._Group.LastIndex]))
end

local Add = function(self, type, ...)
	self.Queue[#self.Queue + 1] = {type, ...}
end

local Play = function(self)
	if (#self.Queue == 0) then
		return
	end
	
	self.Finish = false
	
	self.Owner:Run(unpack(self.Queue[1]))
end

local Stop = function(self)
	self.Finish = true
end

local SetNumLoops = function(self, num)
	self.Looping = true
	self.NumLoops = num or 1
end

local SetLooping = function(self, value)
	self.Looping = value
end

local NewAnimGroup = function(parent)
	if (not parent) then
		return
	end
	
	local Group = CreateFrame("Frame")
	
	Group.Queue = {}
	Group.Owner = parent
	Group.Add = Add
	Group.Play = Play
	Group.Stop = Stop
	Group.SetNumLoops = SetNumLoops
	Group.SetLooping = SetLooping
	Group.LastIndex = 1
	Group.TimesRun = 0
	parent._Group = Group
	
	return Group
end

local AddAPI = function(object)
	local MetaTable = getmetatable(object).__index
	
	if not object.Run then MetaTable.Run = Run end
	if not object.OnFinished then MetaTable.OnFinished = OnFinished end
	if not object.NewAnimGroup then MetaTable.NewAnimGroup = NewAnimGroup end
end

local Handled = {["Frame"] = true}
local Object = CreateFrame("Frame")

AddAPI(Object)
AddAPI(Object:CreateTexture())
AddAPI(Object:CreateFontString())

Object = EnumerateFrames()

while Object do
	if (not Handled[Object:GetObjectType()]) then
		AddAPI(Object)
		Handled[Object:GetObjectType()] = true
	end
	
	Object = EnumerateFrames(Object)
end

_G["LibAnim"] = LibAnim