local LibAnim = LibAnim
local AlphaFrames = CreateFrame("Frame")
local Frame

local OnUpdate = function(self, elapsed)
	local Index = 1
	
	while self[Index] do
		Frame = self[Index]
		Frame._AlphaTimer = Frame._AlphaTimer + elapsed
		
		if (Frame._AlphaTimer < Frame._AlphaDuration) then
			if (Frame._AlphaMode == "in") then
				Frame:SetAlpha((Frame._AlphaTimer / Frame._AlphaDuration) * (Frame._EndAlpha - Frame._StartAlpha) + Frame._StartAlpha)
			elseif (Frame._AlphaMode == "out") then
				Frame:SetAlpha(((Frame._AlphaDuration - Frame._AlphaTimer) / Frame._AlphaDuration) * (Frame._StartAlpha - Frame._EndAlpha) + Frame._EndAlpha)
			end
		else
			Frame:SetAlpha(Frame._EndAlpha)
			table.remove(self, Index)
			LibAnim:Callback(Frame, "Alpha", Frame._AlphaMode, Frame._AlphaDuration, Frame._StartAlpha, Frame._EndAlpha)
			LibAnim:GroupCallback(Frame)
		end
		
		Index = Index + 1
	end
	
	if (#self == 0) then
		self:SetScript("OnUpdate", nil)
	end
end

local Alpha = function(frame, duration, startAlpha, endAlpha)
	frame._AlphaMode = endAlpha > startAlpha and "in" or "out"
	frame._AlphaTimer = 0
	frame._AlphaDuration = duration
	frame._StartAlpha = startAlpha or frame:GetAlpha()
	frame._EndAlpha = endAlpha or frame._AlphaMode == "in" and 1 or 0
	
	table.insert(AlphaFrames, frame)
	
	AlphaFrames:SetScript("OnUpdate", OnUpdate)
end

LibAnim:NewType("Alpha", Alpha)