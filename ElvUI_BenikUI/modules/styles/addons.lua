local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Styles')

local CreateFrame = CreateFrame

local function StyleDBM_Options()
	if not E.db.benikui.skins.addonSkins.dbm or not BUI.AS then
		return
	end

	local DBM_GUI_OptionsFrame = _G.DBM_GUI_OptionsFrame
	DBM_GUI_OptionsFrame:StripTextures()
	DBM_GUI_OptionsFrame:SetTemplate("Transparent")
	DBM_GUI_OptionsFrame:BuiStyle("Outside")
end

local function StyleInFlight()
	if E.db.benikui.skins.variousSkins.inflight ~= true or E.db.benikui.misc.flightMode == true then
		return
	end

	local frame = _G.InFlightBar
	if frame then
		if not frame.isStyled then
			frame:CreateBackdrop("Transparent")
			frame.backdrop:BuiStyle("Outside")
			frame.isStyled = true
		end
	end
end

local function LoadInFlight()
	local f = CreateFrame("Frame")
	f:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
	f:RegisterEvent("UPDATE_MULTI_CAST_ACTIONBAR")

	f:SetScript("OnEvent", function(self, event)
		if event then
			StyleInFlight()
			f:UnregisterEvent(event)
		end
	end)
end

local function KalielsTracker()
	if BUI:IsAddOnEnabled('!KalielsTracker') and E.db.benikui.general.benikuiStyle and E.db.benikui.skins.variousSkins.kt then
		_G['!KalielsTrackerFrame']:BuiStyle('Outside')
	end
end

local function RareTracker()
	if BUI:IsAddOnEnabled('RareTrackerCore') and E.db.benikui.general.benikuiStyle and E.db.benikui.skins.variousSkins.rt then
		_G['RT']:BuiStyle('Outside')
	end
end

local function TomTom()
	if BUI:IsAddOnEnabled('TomTom') and E.db.benikui.general.benikuiStyle and E.db.benikui.skins.variousSkins.tomtom then
		if MyFrameDropDownBackdrop then
			MyFrameDropDownBackdrop:StripTextures()
			MyFrameDropDownBackdrop:SetTemplate("Transparent")
			MyFrameDropDownBackdrop:BuiStyle('Outside')
		end
	end
end

function mod:LoD_AddOns(_, addon)
	if addon == "DBM-GUI" then
		StyleDBM_Options()
	end

	if addon == "InFlight" then
		LoadInFlight()
	end
end

function mod:StyleAddons()
	KalielsTracker()
	RareTracker()
	TomTom()
end
