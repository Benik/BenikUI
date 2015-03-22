local LibAnim = LibAnim
local WidthFrames = CreateFrame("Frame")
local Frame

local OnUpdate = function(self, elapsed)
	local Index = 1
	
	while self[Index] do
		Frame = self[Index]
		Frame._WidthTimer = Frame._WidthTimer + elapsed
		
		if (Frame._WidthTimer < Frame._WidthDuration) then
			Frame:SetWidth((Frame._WidthTimer / Frame._WidthDuration) * (Frame._EndWidth - Frame._StartWidth) + Frame._StartWidth)
		else
			Frame:SetWidth(Frame._EndWidth)
			Frame._WidthChanging = nil
			table.remove(self, Index)
			LibAnim:Callback(Frame, "Width", Frame._WidthDuration, Frame._EndWidth)
			LibAnim:GroupCallback(Frame)
		end
		
		Index = Index + 1
	end
	
	if (#self == 0) then
		self:SetScript("OnUpdate", nil)
	end
end

local Width = function(self, duration, width)
	if self._WidthChanging then
		return
	end
	
	self._WidthTimer = 0
	self._WidthDuration = duration
	self._StartWidth = self:GetWidth()
	self._EndWidth = width or 0
	self._WidthChanging = true
	
	table.insert(WidthFrames, self)
	
	WidthFrames:SetScript("OnUpdate", OnUpdate)
end

LibAnim:NewType("Width", Width)