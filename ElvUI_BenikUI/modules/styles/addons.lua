local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Styles')
local S = E:GetModule('Skins')

local _G = _G

local next = next
local hooksecurefunc = hooksecurefunc

local function StyleDBM_Options()
	if not E.db.benikui.skins.addonSkins.dbm or not BUI.AS then
		return
	end

	local DBM_GUI_OptionsFrame = _G.DBM_GUI_OptionsFrame
	DBM_GUI_OptionsFrame:StripTextures()
	DBM_GUI_OptionsFrame:SetTemplate("Transparent")
	DBM_GUI_OptionsFrame:BuiStyle()
end

local function StyleInFlight()
	local frame = _G.InFlightBar
	if frame then
		if E.db.benikui.misc.flightMode.enable then
			if not frame.isSkinned then
				frame:CreateBackdrop('Transparent', true, true)
				frame.backdrop:SetOutside(frame, 2, 2)
				frame.backdrop:SetBackdropBorderColor(.3, .3, .3, 1)
				frame.backdrop:CreateWideShadow()
				frame.isSkinned = true
			end
		else
			if not frame.isStyled then
				frame:CreateBackdrop("Transparent")
				frame.backdrop:BuiStyle()
				frame.isStyled = true
			end
		end
	end
end

local function LoadInFlight()
	if BUI:IsAddOnEnabled('InFlight') and E.db.benikui.skins.variousSkins.inflight then
		hooksecurefunc(InFlight, 'StartTimer', StyleInFlight)
	end
end

local function KalielsTracker()
	if BUI:IsAddOnEnabled('!KalielsTracker') and E.db.benikui.general.benikuiStyle and E.db.benikui.skins.variousSkins.kt then
		_G['!KalielsTrackerBackground']:BuiStyle()
	end
end

local function RareTracker()
	if BUI:IsAddOnEnabled('RareTrackerCore') and E.db.benikui.general.benikuiStyle and E.db.benikui.skins.variousSkins.rt then
		_G['RT']:BuiStyle()
	end
end

local function TomTom()
	if BUI:IsAddOnEnabled('TomTom') and E.db.benikui.skins.variousSkins.tomtom then

		if _G.MyFrameDropDownBackdrop then
			_G.MyFrameDropDownBackdrop:StripTextures()
			_G.MyFrameDropDownBackdrop:SetTemplate("Transparent")

			if E.db.benikui.general.benikuiStyle then
				_G.MyFrameDropDownBackdrop:BuiStyle()
			end
		end

		if _G.TomTomWorldMapDropdownBackdrop then
			_G.TomTomWorldMapDropdownBackdrop:StripTextures()
			_G.TomTomWorldMapDropdownBackdrop:SetTemplate("Transparent")

			if E.db.benikui.general.benikuiStyle then
				_G.TomTomWorldMapDropdownBackdrop:BuiStyle()
			end
		end

		if _G.TomTomDropdown then --minimap dropdown
			_G.TomTomDropdownBackdrop:StripTextures()
			_G.TomTomDropdownBackdrop:SetTemplate("Transparent")

			if E.db.benikui.general.benikuiStyle then
				_G.TomTomDropdownBackdrop:BuiStyle()
			end
		end

		if _G.TomTomTooltip then
			if E.db.benikui.general.benikuiStyle then
				_G.TomTomTooltip:BuiStyle()
			end
		end
	end
end

local function Baganator() --credits go to plusmouse here https://github.com/Benik/BenikUI/issues/62
	if BUI:IsAddOnEnabled('Baganator') and E.db.benikui.general.benikuiStyle and E.db.benikui.skins.variousSkins.ba then
		_G["Baganator"].API.Skins.RegisterListener(function(details)
			if details.regionType == "ButtonFrame" and _G["Baganator"].API.Skins.GetCurrentSkin() == "elvui" then
				details.region:BuiStyle()
			end
		end)
		if _G["Baganator"].API.Skins.GetCurrentSkin() == "elvui" then
			for _, details in ipairs(_G["Baganator"].API.Skins.GetAllFrames()) do
				if details.regionType == "ButtonFrame" then
					details.region:BuiStyle()
				end
			end
		end
	end
end

local function SkinAllTheThings()
	local att = _G.AllTheThings

	local attFrames = {
		"MiniList",
		"Prime",
		"Tradeskills",
	}

	for _, frame in next, (attFrames) do
		local skinFrame = att:GetWindow(frame)
		if skinFrame and not skinFrame.IsSkinned then
			S:HandleFrame(skinFrame)
			S:HandleScrollBar(skinFrame.ScrollBar)
			skinFrame:BuiStyle()
			skinFrame.IsSkinned = true
		end
	end
end

local function AllTheThings()
	if not (BUI:IsAddOnEnabled('AllTheThings') and E.db.benikui.general.benikuiStyle and E.db.benikui.skins.variousSkins.alltheThings) then return end

	local att = _G.AllTheThings
	att.AddEventHandler("OnReady", SkinAllTheThings)
	att.AddEventHandler("OnWindowCreated", SkinAllTheThings)
end

function mod:LoD_AddOns(_, addon)
	if addon == "DBM-GUI" then
		StyleDBM_Options()
	end
end

function mod:StyleAddons()
	KalielsTracker()
	RareTracker()
	TomTom()
	Baganator()
	AllTheThings()
	LoadInFlight()
end
