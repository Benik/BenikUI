local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Styles')

local CreateFrame = CreateFrame

local function StyleDBM_Options()
	if not E.db.benikuiSkins.addonSkins.dbm or not BUI.AS then
		return
	end

	DBM_GUI_OptionsFrame:HookScript("OnShow", function()
		DBM_GUI_OptionsFrame:BuiStyle("Outside")
	end)
end

local function StyleInFlight()
	if E.db.benikuiSkins.variousSkins.inflight ~= true or E.db.benikui.misc.flightMode == true then
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
	if BUI:IsAddOnEnabled('!KalielsTracker') and E.db.benikui.general.benikuiStyle and E.db.benikuiSkins.variousSkins.kt then
		_G['!KalielsTrackerFrame']:BuiStyle('Outside')
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
end