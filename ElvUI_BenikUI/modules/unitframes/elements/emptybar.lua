--[[local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

-- EmptyBar creation
function UFB:CreateEmptyBar(frame)
	local emptybar = CreateFrame('Frame', nil, frame)
	emptybar:SetFrameStrata('BACKGROUND')
	emptybar:CreateShadow()
	emptybar.shadow:Hide()
	
	return emptybar
end

function UFB:Configure_EmptyBar(frame)
	local emptybar = frame.EmptyBar
	
	if frame.USE_EMPTY_BAR then
		emptybar:Show()
		
		if frame.EMPTY_BARS_TRANSPARENCY then
			emptybar:SetTemplate('Transparent')
		else
			emptybar:SetTemplate('Default')
		end
		
		if frame.EMPTY_BARS_SHADOW then
			emptybar.shadow:Show()
		else
			emptybar.shadow:Hide()
		end
		
		if frame.USE_POWERBAR then
			if frame.USE_POWERBAR_OFFSET or not (frame.POWERBAR_DETACHED or frame.USE_INSET_POWERBAR or frame.USE_MINI_POWERBAR) then
				emptybar:Point('TOPLEFT', frame.Power, 'BOTTOMLEFT', -frame.BORDER, -frame.SPACING)
				emptybar:Point('BOTTOMRIGHT', frame.Power, 'BOTTOMRIGHT', frame.BORDER, -frame.EMPTY_BARS_HEIGHT)
			else
				emptybar:Point('TOPLEFT', frame.Health, 'BOTTOMLEFT', -frame.BORDER, -frame.SPACING)
				emptybar:Point('BOTTOMRIGHT', frame.Health, 'BOTTOMRIGHT', frame.BORDER, -frame.EMPTY_BARS_HEIGHT)			
			end
		else
			emptybar:Point('TOPLEFT', frame.Health, 'BOTTOMLEFT', -frame.BORDER, -frame.SPACING)
			emptybar:Point('BOTTOMRIGHT', frame.Health, 'BOTTOMRIGHT', frame.BORDER, -frame.EMPTY_BARS_HEIGHT)	
		end
	else
		emptybar:Hide()
	end
end

-- EmptyBars in Raid frames
function UFB:ConstructRaidBars()
	local header = _G['ElvUF_Raid']
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if not unitbutton.EmptyBar then
				unitbutton.EmptyBar = UFB:CreateEmptyBar(unitbutton)
			end
		end
	end
end

-- EmptyBars in Raid40 frames
function UFB:ConstructRaid40Bars()
	local header = _G['ElvUF_Raid40']
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if not unitbutton.EmptyBar then
				unitbutton.EmptyBar = UFB:CreateEmptyBar(unitbutton)
			end
		end
	end
end

-- EmptyBars in Party frames
function UFB:ConstructPartyBars()
	local header = _G['ElvUF_Party']
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if not unitbutton.EmptyBar then
				unitbutton.EmptyBar = UFB:CreateEmptyBar(unitbutton)
			end
		end
	end
end

function UFB:InitEmptyBars()
	hooksecurefunc(UF, 'Update_RaidHeader', UFB.ConstructRaidBars)
	hooksecurefunc(UF, 'Update_Raid40Header', UFB.ConstructRaid40Bars)
	hooksecurefunc(UF, 'Update_PartyHeader', UFB.ConstructPartyBars)
end]]