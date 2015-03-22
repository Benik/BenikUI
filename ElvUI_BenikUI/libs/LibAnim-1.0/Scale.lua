local LibAnim = LibAnim
local ScaleFrames = CreateFrame("Frame")
local Frame

local OnUpdate = function(self, elapsed)
	local Index = 1
	
	while self[Index] do
		Frame = self[Index]
		Frame._ScaleTimer = Frame._ScaleTimer + elapsed
		
		if (Frame._ScaleTimer < Frame._ScaleDuration) then
			Frame:SetScale((Frame._ScaleTimer / Frame._ScaleDuration) * (Frame._EndScale - Frame._StartScale) + Frame._StartScale)
		else
			Frame:SetScale(Frame._EndScale)
			table.remove(self, Index)
			LibAnim:Callback(Frame, "Scale", Frame._ScaleDuration, Frame._EndScale)
			LibAnim:GroupCallback(Frame)
		end
		
		Index = Index + 1
	end
	
	if (#self == 0) then
		self:SetScript("OnUpdate", nil)
	end
end

local Scale = function(self, duration, scale)
	self._ScaleTimer = 0
	self._ScaleDuration = duration
	self._StartScale = self:GetScale()
	self._EndScale = scale or 1
	
	table.insert(ScaleFrames, self)
	
	ScaleFrames:SetScript("OnUpdate", OnUpdate)
end

LibAnim:NewType("Scale", Scale)