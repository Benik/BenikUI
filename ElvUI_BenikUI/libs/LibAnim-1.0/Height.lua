local LibAnim = LibAnim
local HeightFrames = CreateFrame("Frame")
local Frame

local OnUpdate = function(self, elapsed)
	local Index = 1
	
	while self[Index] do
		Frame = self[Index]
		Frame._HeightTimer = Frame._HeightTimer + elapsed
		
		if (Frame._HeightTimer < Frame._HeightDuration) then
			Frame:SetHeight((Frame._HeightTimer / Frame._HeightDuration) * (Frame._EndHeight - Frame._StartHeight) + Frame._StartHeight)
		else
			Frame:SetHeight(Frame._EndHeight)
			Frame._HeightChanging = nil
			table.remove(self, Index)
			LibAnim:Callback(Frame, "Height", Frame._HeightDuration, Frame._EndHeight)
			LibAnim:GroupCallback(Frame)
		end
		
		Index = Index + 1
	end
	
	if (#self == 0) then
		self:SetScript("OnUpdate", nil)
	end
end

local Height = function(self, duration, height)
	if self._HeightChanging then
		return
	end
	
	self._HeightTimer = 0
	self._HeightDuration = duration
	self._StartHeight = self:GetHeight()
	self._EndHeight = height or 0
	self._HeightChanging = true
	
	table.insert(HeightFrames, self)
	
	HeightFrames:SetScript("OnUpdate", OnUpdate)
end

LibAnim:NewType("Height", Height)