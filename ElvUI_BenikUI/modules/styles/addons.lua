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
		local frameDropDown = _G.MyFrameDropDownBackdrop
		if frameDropDown then
			frameDropDown:StripTextures()
			frameDropDown:SetTemplate("Transparent")

			if E.db.benikui.general.benikuiStyle then
				frameDropDown:BuiStyle()
			end
		end

		local mapDropDown = _G.TomTomWorldMapDropdownBackdrop
		if mapDropDown then
			mapDropDown:StripTextures()
			mapDropDown:SetTemplate("Transparent")

			if E.db.benikui.general.benikuiStyle then
				mapDropDown:BuiStyle()
			end
		end

		local mapDropDown = _G.TomTomDropdownBackdrop
		if mapDropDown then --minimap dropdown
			mapDropDown:StripTextures()
			mapDropDown:SetTemplate("Transparent")

			if E.db.benikui.general.benikuiStyle then
				mapDropDown:BuiStyle()
			end
		end

		local tomTooltip = _G.TomTomTooltip
		if tomTooltip then
			if E.db.benikui.general.benikuiStyle then
				tomTooltip:BuiStyle()
			end
		end
	end
end

local function Baganator() --credits go to plusmouse here https://github.com/Benik/BenikUI/issues/62
	if BUI:IsAddOnEnabled('Baganator') and E.db.benikui.general.benikuiStyle and E.db.benikui.skins.variousSkins.ba then
		local baganator = _G["Baganator"]
		baganator.API.Skins.RegisterListener(function(details)
			if details.regionType == "ButtonFrame" and baganator.API.Skins.GetCurrentSkin() == "elvui" then
				details.region:BuiStyle()
			end
		end)

		if baganator.API.Skins.GetCurrentSkin() == "elvui" then
			for _, details in ipairs(baganator.API.Skins.GetAllFrames()) do
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

local function MinimapButtonButton()
	if not (BUI:IsAddOnEnabled('MinimapButtonButton') and E.db.benikui.general.benikuiStyle and E.db.benikui.skins.variousSkins.minimapbb) then return end

	local mainButton = _G.MinimapButtonButtonButton
	if not mainButton then return end

	local children = { mainButton:GetChildren() }

	if not mainButton.style then
		mainButton:BuiStyle()
	end

	for _, child in ipairs(children) do
		if child:IsObjectType('Frame') and not child.style then
			child:BuiStyle()
			if not (E.db.benikui.general.benikuiStyle and E.db.benikui.general.shadows) then return end

			-- force move the child frame a bit to help the shadows
			child:ClearAllPoints()
			child:Point('RIGHT', mainButton, 'LEFT', -2, 0)

			local isMoving = false
			hooksecurefunc(child, "SetPoint", function(self)
				if isMoving then return end
				isMoving = true

				self:ClearAllPoints()
				self:Point('RIGHT', mainButton, 'LEFT', -2, 0)

				isMoving = false
			end)
		end
	end
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
	MinimapButtonButton()
end
