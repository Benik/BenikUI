-- BenikUI
-- Edit ElvUI dropdown.lua to make a steady dropup menu. The menu position is not related anymore on where the mouse is clicked.
-- args: menuList, menuFrame, parentButtonName, position, xOffset, yOffset, delay
local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local BUI = E:GetModule('BenikUI');

local PADDING = 10
local BUTTON_HEIGHT = 16
local BUTTON_WIDTH = 135
local counter = 0
local hoverVisible = false
local tinsert = table.insert

local function OnClick(btn)
	local parent = btn:GetParent()
	btn.func()
	UIFrameFadeOut(parent, 0.3, parent:GetAlpha(), 0)
	parent.fadeInfo.finishedFunc = function() parent:Hide() end
end

local function OnEnter(btn)
	btn.hoverTex:Show()
	hoverVisible = true
end

local function OnLeave(btn)
	btn.hoverTex:Hide()
	hoverVisible = false
end

local color = { r = 1, g = 1, b = 1 }
local function unpackColor(color)
	return color.r, color.g, color.b
end

-- added parent, removed the mouse x,y and set menu frame position to any parent corners.
-- Also added delay to autohide
function BUI:Dropmenu(list, frame, parent, pos, xOffset, yOffset, delay)
	if not frame.buttons then
		frame.buttons = {}
		frame:SetParent(parent)
		frame:SetFrameStrata('DIALOG')
		frame:SetClampedToScreen(true)
		tinsert(UISpecialFrames, frame:GetName())
		frame:Hide()
	end

	xOffset = xOffset or 0
	yOffset = yOffset or 0

	for i=1, #frame.buttons do
		frame.buttons[i]:Hide()
	end

	for i=1, #list do 
		if not frame.buttons[i] then
			frame.buttons[i] = CreateFrame('Button', nil, frame)
			
			frame.buttons[i].hoverTex = frame.buttons[i]:CreateTexture(nil, 'OVERLAY')
			frame.buttons[i].hoverTex:SetAllPoints()
			frame.buttons[i].hoverTex:SetTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
			frame.buttons[i].hoverTex:SetBlendMode('ADD')
			frame.buttons[i].hoverTex:Hide()

			frame.buttons[i].text = frame.buttons[i]:CreateFontString(nil, 'BORDER')
			frame.buttons[i].text:SetAllPoints()
			frame.buttons[i].text:FontTemplate()
			frame.buttons[i].text:SetJustifyH('LEFT')

			frame.buttons[i]:SetScript('OnEnter', OnEnter)
			frame.buttons[i]:SetScript('OnLeave', OnLeave)			
		end

		frame.buttons[i]:Show()
		frame.buttons[i]:SetHeight(BUTTON_HEIGHT)
		frame.buttons[i]:SetWidth(BUTTON_WIDTH)
		frame.buttons[i].text:SetText(list[i].text)
		frame.buttons[i].text:SetTextColor(unpackColor(E.db.bui.gameMenuColor))
		frame.buttons[i].func = list[i].func
		frame.buttons[i]:SetScript('OnClick', OnClick)

		if i == 1 then
			frame.buttons[i]:SetPoint('TOPLEFT', frame, 'TOPLEFT', PADDING, -PADDING)
		else
			frame.buttons[i]:SetPoint('TOPLEFT', frame.buttons[i-1], 'BOTTOMLEFT')
		end
	end
	
	frame:SetScript('OnShow', function(self)
		UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
	end)

	frame:SetScript('OnUpdate', function(self, elapsed)
		if hoverVisible then return end
		counter = counter + elapsed
		if counter >= delay then
			UIFrameFadeOut(self, 0.3, self:GetAlpha(), 0)
			self.fadeInfo.finishedFunc = function() self:Hide() end
			counter = 0
		end	
	end)
	
	frame:SetHeight((#list * BUTTON_HEIGHT) + PADDING * 2)
	frame:SetWidth(BUTTON_WIDTH + PADDING * 2)
	frame:Style('Outside')
	frame:ClearAllPoints()
	if pos == 'tLeft' then
		frame:SetPoint('BOTTOMRIGHT', parent, 'TOPLEFT', xOffset, yOffset)
	elseif pos == 'tRight' then
		frame:SetPoint('BOTTOMLEFT', parent, 'TOPRIGHT', xOffset, yOffset)
	elseif pos == 'bLeft' then
		frame:SetPoint('TOPRIGHT', parent, 'BOTTOMLEFT', xOffset, yOffset)
	elseif pos == 'bRight' then
		frame:SetPoint('TOPLEFT', parent, 'BOTTOMRIGHT', xOffset, yOffset)				
	end

	ToggleFrame(frame)
end