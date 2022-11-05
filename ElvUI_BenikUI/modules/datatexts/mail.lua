local E, L, V, P, G = unpack(ElvUI);
local DT = E:GetModule('DataTexts')

local HasNewMail = HasNewMail
local GetInboxNumItems = GetInboxNumItems
local GetInboxHeaderInfo = GetInboxHeaderInfo
local GetLatestThreeSenders = GetLatestThreeSenders

local HAVE_MAIL, HAVE_MAIL_FROM = HAVE_MAIL, HAVE_MAIL_FROM

-- GLOBALS: MiniMapMailFrame

local Read;
local unreadMail;

local function OnEvent(self, event, ...)
	local newMail = false

	if event == 'UPDATE_PENDING_MAIL' or event == 'PLAYER_ENTERING_WORLD' or event =='PLAYER_LOGIN' then

		newMail = HasNewMail()

		if unreadMail ~= newMail then
			unreadMail = newMail
		end

		self:UnregisterEvent('PLAYER_ENTERING_WORLD')
		self:UnregisterEvent('PLAYER_LOGIN')
	end

	if event == 'MAIL_INBOX_UPDATE' or event == 'MAIL_SHOW' or event == 'MAIL_CLOSED' then
		for i = 1, GetInboxNumItems() do
			local _, _, _, _, _, _, _, _, wasRead = GetInboxHeaderInfo(i)
			if( not wasRead ) then
				newMail = true
				break
			end
		end
	end

	if newMail then
		self.text:SetFormattedText("|cff00ff00%s|r", L['New Mail'])
		Read = false
	else
		self.text:SetFormattedText("%s", L['No Mail'])
		Read = true
	end
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	local sender1, sender2, sender3 = GetLatestThreeSenders()

	if not Read then

		if (sender1 or sender2 or sender3) then
			DT.tooltip:AddLine(HAVE_MAIL_FROM)
		else
			DT.tooltip:AddLine(HAVE_MAIL)
		end

		if sender1 then DT.tooltip:AddLine(sender1) end
		if sender2 then DT.tooltip:AddLine(sender2) end
		if sender3 then DT.tooltip:AddLine(sender3) end

	end
	DT.tooltip:Show()
end

-- Hide the mail icon from minimap
function DT:ToggleMailFrame()
	local MiniMapMailFrame = MinimapCluster.MailFrame or _G.MiniMapMailFrame
	if E.db.benikui.datatexts.mail.toggle then
		if MiniMapMailFrame then
			MiniMapMailFrame.Show = MiniMapMailFrame.Hide
			MiniMapMailFrame:Hide()
		end
	end
end

DT:RegisterDatatext('BuiMail', 'BenikUI', {'PLAYER_ENTERING_WORLD', 'MAIL_INBOX_UPDATE', 'UPDATE_PENDING_MAIL', 'MAIL_CLOSED', 'PLAYER_LOGIN','MAIL_SHOW'}, OnEvent, nil, nil, OnEnter)