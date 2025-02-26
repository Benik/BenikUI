local E, L, V, P, G = unpack(ElvUI);
local DT = E:GetModule('DataTexts')

local next = next
local pairs = pairs
local HasNewMail = HasNewMail
local GetLatestThreeSenders = GetLatestThreeSenders
local HAVE_MAIL_FROM = HAVE_MAIL_FROM
local MAIL_LABEL = MAIL_LABEL

local function OnEvent(self)
	if HasNewMail() then
		self.text:SetFormattedText("|cff00ff00%s|r", L['New Mail'])
	else
		self.text:SetFormattedText("%s", L['No Mail'])
	end

	if _G.MiniMapMailIcon then
		_G.MiniMapMailIcon:SetShown(not E.db.benikui.datatexts.mail.toggle)
	end
end

local function OnEnter()
	DT.tooltip:ClearLines()

	local senders = { GetLatestThreeSenders() }
	if not next(senders) then return end

	DT.tooltip:AddLine(HasNewMail() and HAVE_MAIL_FROM or MAIL_LABEL, 1, 1, 1)
	DT.tooltip:AddLine(' ')

	for _, sender in pairs(senders) do
		DT.tooltip:AddLine(sender)
	end

	DT.tooltip:Show()
end

DT:RegisterDatatext('BuiMail', 'BenikUI', {'MAIL_INBOX_UPDATE', 'UPDATE_PENDING_MAIL', 'MAIL_CLOSED', 'MAIL_SHOW'}, OnEvent, nil, nil, OnEnter, nil, 'Mail (BenikUI)')