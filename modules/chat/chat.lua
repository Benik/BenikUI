local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local CH = E:GetModule('Chat')
local LSM = LibStub("LibSharedMedia-3.0")

--[[ Copy Chat button
CH.BenikStyleChat = CH.StyleChat
function CH:StyleChat(frame)
	self:BenikStyleChat(frame)
	frame.button:SetPoint('TOPRIGHT', 0, 7)
end]]

E.BenikUpdateBlizzardFonts = E.UpdateBlizzardFonts
function E:UpdateBlizzardFonts()
	self:BenikUpdateBlizzardFonts()
	
	CHAT_FONT_HEIGHTS = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}
	
	local COMBAT	= LSM:Fetch('font', [[Interface\AddOns\ElvUI_BenikUI\media\fonts\PROTOTYPE.TTF]])
	local NAMEFONT	= LSM:Fetch('font', [[Interface\AddOns\ElvUI_BenikUI\media\fonts\PROTOTYPE.TTF]])
	
	UNIT_NAME_FONT	= NAMEFONT
	--SetFont(CombatTextFont, COMBAT, 100, "OUTLINE") -- number here just increase the font quality.
end

--[[ Copy Chat frame
CH.BenikInitialize = CH.Initialize
function CH:Initialize()
	self:BenikInitialize()

	CopyChatFrame:Point('BOTTOM', E.UIParent, 'BOTTOM', 0, 22)
end

function CH:PositionChat(override)
	if not self.db.lockPositions or ((InCombatLockdown() and not override and self.initialMove) or (IsMouseButtonDown("LeftButton") and not override)) then return end
	if not RightChatPanel or not LeftChatPanel then return; end
	RightChatPanel:Size(E.db.chat.panelWidth, E.db.chat.panelHeight)
	LeftChatPanel:Size(E.db.chat.panelWidth, E.db.chat.panelHeight)	
	
	if E.private.chat.enable ~= true then return end
		
	local chat, chatbg, tab, id, point, button, isDocked, chatFound
	for _, frameName in pairs(CHAT_FRAMES) do
		chat = _G[frameName]
		id = chat:GetID()
		point = GetChatWindowSavedPosition(id)
		
		if point == "BOTTOMRIGHT" and chat:IsShown() then
			chatFound = true
			break
		end
	end	

	if chatFound then
		self.RightChatWindowID = id
	else
		self.RightChatWindowID = nil
	end
	
	CreatedFrames = id

	for i=1, CreatedFrames do
		local BASE_OFFSET = 46 -- from 60
		if E.PixelMode then
			BASE_OFFSET = BASE_OFFSET - 3
		end	
		chat = _G[format("ChatFrame%d", i)]
		chatbg = format("ChatFrame%dBackground", i)
		button = _G[format("ButtonCF%d", i)]
		id = chat:GetID()
		tab = _G[format("ChatFrame%sTab", i)]
		point = GetChatWindowSavedPosition(id)
		isDocked = chat.isDocked
		
		if id > NUM_CHAT_WINDOWS then
			if point == nil then
				point = select(1, chat:GetPoint())
			end
			if select(2, tab:GetPoint()):GetName() ~= bg then
				isDocked = true
			else
				isDocked = false
			end	
		end	

		if point == "BOTTOMRIGHT" and chat:IsShown() and not (id > NUM_CHAT_WINDOWS) and id == self.RightChatWindowID then
			chat:ClearAllPoints()
			if E.db.datatexts.rightChatPanel then
				chat:Point("BOTTOMLEFT", RightChatDataPanel, "TOPLEFT", 4, 4)
			else
				BASE_OFFSET = BASE_OFFSET - 24
				chat:Point("BOTTOMLEFT", RightChatDataPanel, "BOTTOMLEFT", 1, 1)
			end
			if id ~= 2 then
				chat:SetSize(E.db.chat.panelWidth - 11, (E.db.chat.panelHeight - BASE_OFFSET))
			else
				chat:Size(E.db.chat.panelWidth - 11, (E.db.chat.panelHeight - BASE_OFFSET) - CombatLogQuickButtonFrame_Custom:GetHeight())				
			end
			
			
			FCF_SavePositionAndDimensions(chat)			
			
			tab:SetParent(RightChatPanel)
			chat:SetParent(RightChatPanel)
			chat:SetJustifyH("RIGHT") -- Justify Right
			
			if chat:IsMovable() then
				chat:SetUserPlaced(true)
			end
			if E.db.chat.panelBackdrop == 'HIDEBOTH' or E.db.chat.panelBackdrop == 'LEFT' then
				CH:SetupChatTabs(tab, true)
			else
				CH:SetupChatTabs(tab, false)
			end
		elseif not isDocked and chat:IsShown() then
			tab:SetParent(UIParent)
			chat:SetParent(UIParent)
			
			CH:SetupChatTabs(tab, true)
		else
			if id ~= 2 and not (id > NUM_CHAT_WINDOWS) then
				chat:ClearAllPoints()
				if E.db.datatexts.leftChatPanel then
					chat:Point("BOTTOMLEFT", LeftChatToggleButton, "TOPLEFT", 4, 4)
				else
					BASE_OFFSET = BASE_OFFSET - 24
					chat:Point("BOTTOMLEFT", LeftChatToggleButton, "BOTTOMLEFT", 1, 1)
				end
				chat:Size(E.db.chat.panelWidth - 11, (E.db.chat.panelHeight - BASE_OFFSET))
				FCF_SavePositionAndDimensions(chat)		
			end
			chat:SetParent(LeftChatPanel)
			if i > 2 then
				tab:SetParent(GeneralDockManagerScrollFrameChild)
			else
				tab:SetParent(GeneralDockManager)
			end
			if chat:IsMovable() then
				chat:SetUserPlaced(true)
			end
			
			if E.db.chat.panelBackdrop == 'HIDEBOTH' or E.db.chat.panelBackdrop == 'RIGHT' then
				CH:SetupChatTabs(tab, true)
			else
				CH:SetupChatTabs(tab, false)
			end			
		end		
	end
	
	self.initialMove = true;
end]]
