local LibAnim = LibAnim
local MoveFrames = CreateFrame("Frame")
local Frame

local OnUpdate = function(self, elapsed)
	local Index = 1
	
	while self[Index] do
		Frame = self[Index]
		Frame._MoveTimer = Frame._MoveTimer + elapsed
		
		Frame._XOffset = (Frame._MoveTimer / Frame._MoveDuration) * (Frame._EndX - Frame._StartX) + Frame._StartX
		Frame._YOffset = (Frame._MoveTimer / Frame._MoveDuration) * (Frame._EndY - Frame._StartY) + Frame._StartY
		
		if (Frame._MoveTimer < Frame._MoveDuration) then
			Frame:Point(Frame._A1, Frame._P, Frame._A2, (Frame._EndX ~= 0 and Frame._XOffset or Frame._StartX), (Frame._EndY ~= 0 and Frame._YOffset or Frame._StartY))
		else
			Frame:Point(Frame._A1, Frame._P, Frame._A2, (Frame._EndX ~= 0 and Frame._EndX or Frame._StartX), (Frame._EndY ~= 0 and Frame._EndY or Frame._StartY))
			Frame._IsMoving = nil
			table.remove(self, Index)
			LibAnim:Callback(Frame, "Width", Frame._MoveDuration, Frame._EndX, Frame._EndY)
			LibAnim:GroupCallback(Frame)
		end
		
		Index = Index + 1
	end
	
	if (#self == 0) then
		self:SetScript("OnUpdate", nil)
	end
end

local Move = function(frame, duration, x, y)
	if frame._IsMoving then
		return
	end
	
	local A1, P, A2, X, Y = frame:GetPoint()
	
	frame._MoveTimer = 0
	frame._MoveDuration = duration
	frame._XOffset = 0
	frame._YOffset = 0
	frame._StartX = X
	frame._EndX = frame._StartX + x
	frame._StartY = Y
	frame._EndY = frame._StartY + y
	frame._A1 = A1
	frame._P = P
	frame._A2 = A2
	frame._IsMoving = true
	
	table.insert(MoveFrames, frame)
	
	MoveFrames:SetScript("OnUpdate", OnUpdate)
end

LibAnim:NewType("Move", Move)