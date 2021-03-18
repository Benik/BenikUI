-- BenikUI
-- Edit ElvUI dropdown.lua to make a steady dropup menu. The menu position is not related anymore on where the mouse is clicked.
-- args: menuList, menuFrame, parentButtonName, position, xOffset, yOffset, delay
local BUI, E, L, V, P, G = unpack(select(2, ...))
local tinsert, unpack = table.insert, unpack

local PADDING = 10
local BUTTON_HEIGHT = 16
local BUTTON_WIDTH = 135
local counter = 0
local hoverVisible = false

local CreateFrame, ToggleFrame = CreateFrame, ToggleFrame
local UIFrameFadeOut, UIFrameFadeIn, UISpecialFrames = UIFrameFadeOut, UIFrameFadeIn, UISpecialFrames

local classColor = E:ClassColor(E.myclass, true)

BUI.MenuList = {
	{text = CHARACTER_BUTTON, func = function() ToggleCharacter("PaperDollFrame") end},
	{text = SPELLBOOK_ABILITIES_BUTTON, func = function() if not SpellBookFrame:IsShown() then ShowUIPanel(SpellBookFrame) else HideUIPanel(SpellBookFrame) end end},
	{text = SPECIALIZATION,
	func = function()
		if not PlayerTalentFrame then
			TalentFrame_LoadUI()
		end

		if not PlayerTalentFrame:IsShown() then
			ShowUIPanel(PlayerTalentFrame)
			_G["PlayerTalentFrameTab"..SPECIALIZATION_TAB]:Click()
		else
			HideUIPanel(PlayerTalentFrame)
		end
	end},
	{text = TALENTS,
	func = function()
		if not PlayerTalentFrame then
			TalentFrame_LoadUI()
		end

		if not PlayerTalentFrame:IsShown() then
			ShowUIPanel(PlayerTalentFrame)
			_G["PlayerTalentFrameTab"..TALENTS_TAB]:Click()
		else
			HideUIPanel(PlayerTalentFrame)
		end
	end},
	{text = LFG_TITLE, func = function() ToggleLFDParentFrame(); end},
	{text = ACHIEVEMENT_BUTTON, func = function() ToggleAchievementFrame() end},
	{text = REPUTATION, func = function() ToggleCharacter('ReputationFrame') end},
	{text = GARRISON_TYPE_9_0_LANDING_PAGE_TITLE, func = function()
		if (C_Garrison.HasGarrison(Enum.GarrisonType.Type_9_0)) then
			ShowGarrisonLandingPage(Enum.GarrisonType.Type_9_0) -- errors the ElvUI Skin
		end
	end},
	{text = COMMUNITIES_FRAME_TITLE, func = function() ToggleGuildFrame() end},
	{text = L["Calendar"], func = function() GameTimeFrame:Click() end},
	{text = MOUNTS, func = function() ToggleCollectionsJournal(1) end},
	{text = PET_JOURNAL, func = function() ToggleCollectionsJournal(2) end},
	{text = TOY_BOX, func = function() ToggleCollectionsJournal(3) end},
	{text = HEIRLOOMS, func = function() ToggleCollectionsJournal(4) end},
	{text = WARDROBE, func = function() ToggleCollectionsJournal(5) end},
	{text = MACROS, func = function() GameMenuButtonMacros:Click() end},
	{text = TIMEMANAGER_TITLE, func = function() ToggleFrame(TimeManagerFrame) end},
	{text = ADVENTURE_JOURNAL, func = function() if not IsAddOnLoaded('Blizzard_EncounterJournal') then EncounterJournal_LoadUI(); end ToggleFrame(EncounterJournal) end},
	{text = SOCIAL_BUTTON, func = function() ToggleFriendsFrame() end},
	{text = MAINMENU_BUTTON,
	func = function()
		if ( not GameMenuFrame:IsShown() ) then
			if ( VideoOptionsFrame:IsShown() ) then
					VideoOptionsFrameCancel:Click();
			elseif ( AudioOptionsFrame:IsShown() ) then
					AudioOptionsFrameCancel:Click();
			elseif ( InterfaceOptionsFrame:IsShown() ) then
					InterfaceOptionsFrameCancel:Click();
			end
			CloseMenus();
			CloseAllWindows()
			ShowUIPanel(GameMenuFrame);
		else
			HideUIPanel(GameMenuFrame);
			MainMenuMicroButton_SetNormal();
		end
	end},
	{text = HELP_BUTTON, func = function() ToggleHelpFrame() end},
	{text = BLIZZARD_STORE, func = function() StoreMicroButton:Click() end}
}

local function sortFunction(a, b)
	return a.text < b.text
end

table.sort(BUI.MenuList, sortFunction)

local function OnClick(btn)
	local parent = btn:GetParent()
	btn.func()
	UIFrameFadeOut(parent, 0.3, parent:GetAlpha(), 0)
	parent.fadeInfo.finishedFunc = function() parent:Hide() end
end

local function OnEnter(btn)
	E:UIFrameFadeIn(btn.hoverTex, .3, 0, 1)
	hoverVisible = true
end

local function OnLeave(btn)
	E:UIFrameFadeOut(btn.hoverTex, .3, 1, 0)
	hoverVisible = false
end

-- added parent, removed the mouse x,y and set menu frame position to any parent corners.
-- Also added delay to autohide
function BUI:Dropmenu(list, frame, parent, pos, xOffset, yOffset, delay, addedSize)
	local db = E.db.benikui.colors.gameMenuColor
	
	local r, g, b
	if db == 1 then
		r, g, b = classColor.r, classColor.g, classColor.b
	elseif db == 2 then
		r, g, b = BUI:unpackColor(E.db.benikui.colors.customGameMenuColor)
	elseif db == 3 then
		r, g, b = unpack(E.media.rgbvaluecolor)
	else
		r, g, b = BUI:getCovenantColor()
	end

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
			frame.buttons[i] = CreateFrame('Button', nil, frame, 'BackdropTemplate')

			frame.buttons[i].hoverTex = frame.buttons[i]:CreateTexture(nil, 'OVERLAY')
			frame.buttons[i].hoverTex:SetAllPoints()
			frame.buttons[i].hoverTex:SetTexture(E.Media.Textures.Highlight)
			frame.buttons[i].hoverTex:SetBlendMode('BLEND')
			frame.buttons[i].hoverTex:SetDrawLayer('BACKGROUND')
			frame.buttons[i].hoverTex:SetAlpha(0)

			frame.buttons[i].text = frame.buttons[i]:CreateFontString(nil, 'BORDER')
			frame.buttons[i].text:SetAllPoints()
			frame.buttons[i].text:FontTemplate()
			frame.buttons[i].text:SetJustifyH('LEFT')

			frame.buttons[i]:SetScript('OnEnter', OnEnter)
			frame.buttons[i]:SetScript('OnLeave', OnLeave)
		end

		frame.buttons[i]:Show()
		frame.buttons[i]:Height(BUTTON_HEIGHT)
		frame.buttons[i]:Width(BUTTON_WIDTH + (addedSize or 0))
		frame.buttons[i].text:SetText(list[i].text)
		frame.buttons[i].text:SetTextColor(r, g, b)
		frame.buttons[i].hoverTex:SetVertexColor(r, g, b)
		frame.buttons[i].func = list[i].func
		frame.buttons[i]:SetScript('OnClick', OnClick)

		if i == 1 then
			frame.buttons[i]:Point('TOPLEFT', frame, 'TOPLEFT', PADDING, -PADDING)
		else
			frame.buttons[i]:Point('TOPLEFT', frame.buttons[i-1], 'BOTTOMLEFT')
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

	frame:Height((#list * BUTTON_HEIGHT) + PADDING * 2)
	frame:Width(BUTTON_WIDTH + PADDING * 2 + (addedSize or 0))
	frame:BuiStyle('Outside')
	frame:ClearAllPoints()
	if pos == 'tLeft' then
		frame:Point('BOTTOMRIGHT', parent, 'TOPLEFT', xOffset, yOffset)
	elseif pos == 'tRight' then
		frame:Point('BOTTOMLEFT', parent, 'TOPRIGHT', xOffset, yOffset)
	elseif pos == 'bLeft' then
		frame:Point('TOPRIGHT', parent, 'BOTTOMLEFT', xOffset, yOffset)
	elseif pos == 'bRight' then
		frame:Point('TOPLEFT', parent, 'BOTTOMRIGHT', xOffset, yOffset)
	end

	ToggleFrame(frame)
end