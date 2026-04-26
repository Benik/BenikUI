local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Styles')
local S = E:GetModule('Skins')

local _G = _G

local next = next
local ipairs = ipairs
local hooksecurefunc = hooksecurefunc

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
S:AddCallback("BenikUI_InFlight", LoadInFlight)

local function KalielsTracker()
	if not (BUI:IsAddOnEnabled('!KalielsTracker') and E.db.benikui.skins.variousSkins.kt) then return end
	_G['!KalielsTrackerBackground']:BuiStyle()

	-- Skin the EditMode
	local ACD = _G.LibStub("MSA-AceConfigDialog-3.0", true)
	if ACD then
		hooksecurefunc(ACD, "Open", function(self, appName)
			local widget = self.OpenFrames and self.OpenFrames[appName]

			if widget and widget.frame and not widget.frame.isSkinned then
				local f = widget.frame

				f:StripTextures()
				f:SetTemplate("Transparent")
				f:BuiStyle()

				if widget.closebutton then
					S:HandleButton(widget.closebutton)
				end

				if widget.titlebg then widget.titlebg:SetAlpha(0) end
				if widget.statbg then widget.statbg:SetAlpha(0) end

				f.isSkinned = true
			end
		end)
	end

	local GUI = _G.LibStub("AceGUI-3.0", true)
	if GUI then
		hooksecurefunc(GUI, "RegisterAsWidget", function(_, widget)
			local slider = widget.slider	 -- dunno why this isn't skinned by ElvUI
			if slider and not slider.isSkinned then
				S:HandleSliderFrame(slider)
				slider.isSkinned = true
			end
		end)
	end
end
S:AddCallback("BenikUI_KalielsTracker", KalielsTracker)

local function RareTracker()
	if BUI:IsAddOnEnabled('RareTrackerCore') and E.db.benikui.skins.variousSkins.rt then
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
S:AddCallback("BenikUI_TomTom", TomTom)

local function Baganator() --credits go to plusmouse here https://github.com/Benik/BenikUI/issues/62
	if BUI:IsAddOnEnabled('Baganator') and E.db.benikui.skins.variousSkins.ba then
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
	if not (BUI:IsAddOnEnabled('AllTheThings') and E.db.benikui.skins.variousSkins.alltheThings) then return end

	local att = _G.AllTheThings
	att.AddEventHandler("OnReady", SkinAllTheThings)
	att.AddEventHandler("OnWindowCreated", SkinAllTheThings)
end
S:AddCallback("BenikUI_ATT", AllTheThings)

local function MinimapButtonButton()
	if not (BUI:IsAddOnEnabled('MinimapButtonButton') and E.db.benikui.skins.variousSkins.minimapbb) then return end

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
S:AddCallback("BenikUI_MBB", MinimapButtonButton)

function mod:StyleAddons()
	RareTracker()
	Baganator()
end
