local BUI, E, L, V, P, G = unpack((select(2, ...)))
local S = E:GetModule('Skins')
local mod = BUI:GetModule('Skins')

local _G = _G

local next = next
local ipairs = ipairs
local hooksecurefunc = hooksecurefunc

------------------
-- AllTheThings --
------------------
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

---------------
-- Baganator --
---------------
local function Baganator() --credits go to plusmouse here https://github.com/Benik/BenikUI/issues/62
	if not (BUI:IsAddOnEnabled('Baganator') and E.db.benikui.skins.variousSkins.baganator) then return end

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
S:AddCallback("BenikUI_Baganator", Baganator)

-------------
-- BugSack --
-------------
local function BugSack()
	if not (BUI:IsAddOnEnabled('BugSack') and E.db.benikui.skins.variousSkins.bugSack) then return end

	local BugSack = _G.BugSack
	if not BugSack then return end

	hooksecurefunc(BugSack, "OpenSack", function()
		if _G.BugSackFrame.IsSkinned then return end

		local frame = _G.BugSackFrame
		S:HandleFrame(frame)

		local tabs = { _G.BugSackTabAll, _G.BugSackTabSession, _G.BugSackTabLast }
		for _, tab in next, tabs do
			S:HandleTab(tab)
			if E.db.benikui.general.benikuiStyle and E.db.benikui.general.shadows then
				tab.backdrop:CreateSoftShadow()
			end
		end

		_G.BugSackTabAll:SetPoint("TOPLEFT", frame, "BOTTOMLEFT")

		local buttons = { _G.BugSackNextButton, _G.BugSackSendButton, _G.BugSackPrevButton }
		for _, button in next, buttons do
			S:HandleButton(button)
		end

		S:HandleScrollBar(_G.BugSackScrollScrollBar)
			if not frame.style then
				frame:BuiStyle()
			end

		for _, child in pairs({frame:GetChildren()}) do
			if (child:IsObjectType('Button') and child:GetScript('OnClick') == BugSack.CloseSack) then
				S:HandleCloseButton(child)
				break
			end
		end
		_G.BugSackFrame.IsSkinned = true
	end)
end
S:AddCallback("BenikUI_BugSackSkin", BugSack)

----------------
-- ClassCodex --
----------------
local function ClassCodex()
	if not (BUI:IsAddOnEnabled('ClassCodex') and E.db.benikui.skins.variousSkins.classCodex) then return end

	local shadowsEnabled = E.db.benikui.general.benikuiStyle and E.db.benikui.general.shadows
	local frame = _G.ClassCodexPanel
	if frame then
		frame:StripTextures()
		frame:SetTemplate("Transparent")
		frame:BuiStyle()
	end

	local loadoutDock = _G.ClassCodexLoadoutDock
	if loadoutDock then
		loadoutDock:StripTextures()
		loadoutDock:SetTemplate("Transparent")
		if shadowsEnabled then
			loadoutDock:CreateSoftShadow()
		end
	end

	local function HuntCloseButton(parent)
		for _, child in ipairs({parent:GetChildren()}) do
			if child:IsObjectType("Button") then
				local width, height = child:GetSize()
				if math.floor(width) == 20 and math.floor(height) == 20 then -- size is 20
					local point = child:GetPoint(1)
					if point == "RIGHT" then -- and pointed right
						return child
					end
				end
			end
			-- search deeper
			if child:GetNumChildren() > 0 then
				local found = HuntCloseButton(child)
				if found then return found end
			end
		end
		return nil
	end

	local closeBtn = HuntCloseButton(frame)
	if closeBtn then
		S:HandleCloseButton(closeBtn)
	end

	local dropDowns = {
		_G.ClassCodexHeroDropdown,
		_G.ClassCodexRotCtxDropdown,
		_G.ClassCodexDockEnhancementsSourceDropdown,
		_G.ClassCodexStatTargetCtxDropdown,
		_G.ClassCodexTrinketCtxDropdown,
		_G.ClassCodexAllTalentSourceDropdown,
		_G.ClassCodexBisSourceDropdown,
	}
	for _, dropDown in next, dropDowns do
		if dropDown then
			S:HandleDropDownBox(dropDown)
		end
	end

	-- tabs
	frame:HookScript("OnShow", function(self)
		for _, child in ipairs({self:GetChildren()}) do
			if child.IsObjectType and child:IsObjectType("Button") then
				child:SetTemplate("Transparent")
				child:Size(24)
				if child.border then print("hasborder") end
				S:HandleIcon(child.icon, false)
				if shadowsEnabled then
					child:CreateSoftShadow()
				end
			end
		end
	end)

	local function ApplySkin()
		local compendium = _G["ClassCodexCompendium"]
		if not compendium then
			C_Timer.After(0.1, ApplySkin)
			return
		end

		if compendium.isSkinned then return end

		compendium:StripTextures()
		compendium:SetTemplate("Transparent")
		compendium:BuiStyle()

		_G.ClassCodexCompendiumPortrait:Hide()

		S:HandleCloseButton(_G.ClassCodexCompendiumCloseButton)

		local compendiumDropDowns = {
			_G.ClassCodexCompHeroDD,
			_G.ClassCodexCompClassDD,
			_G.ClassCodexCompSpecDD,
			_G.ClassCodexCompStatCtxDD,
			_G.ClassCodexCompBisSourceDD,
			_G.ClassCodexCompBisTabDD,
			_G.ClassCodexCompTrinketCtxDD,
			_G.ClassCodexCompendiumTalentSourceDropdown,
			_G.ClassCodexCompEnhancementsSourceDD,
		}
		for _, dropDown in ipairs(compendiumDropDowns) do
			S:HandleDropDownBox(dropDown)
		end
		_G.ClassCodexCompHeroDD:Point("TOPRIGHT", compendium, "TOPRIGHT", -30, -28)

		for i = 1, 6 do
			local tab = _G["ClassCodexCompendiumTab"..i]
			if tab then
				S:HandleTab(tab)
				if shadowsEnabled then
					tab.backdrop:CreateSoftShadow()
				end
				if i == 1 then
					tab:Point("BOTTOMLEFT", compendium, "BOTTOMLEFT", 15, -32)
				end
			end
		end

		S:HandleScrollBar(_G.ClassCodexCompendiumScrollScrollBar)
		compendium.isSkinned = true
	end
	-- add another delay. The compendium is lazy
	C_Timer.After(0.1, ApplySkin)
end
S:AddCallback("BenikUI_ClassCodex", ClassCodex)

--------------
-- InFlight --
--------------
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
	if not (BUI:IsAddOnEnabled('InFlight') and E.db.benikui.skins.variousSkins.inflight) then return end

	hooksecurefunc(InFlight, 'StartTimer', StyleInFlight)
end
S:AddCallback("BenikUI_InFlight", LoadInFlight)


--------------------
-- KalielsTracker --
--------------------
local function KalielsTracker()
	if not (BUI:IsAddOnEnabled('!KalielsTracker') and E.db.benikui.skins.variousSkins.kt) then return end

	_G['!KalielsTrackerBackground']:BuiStyle()

	local ktButton = _G['!KalielsTrackerActiveButton']
	if ktButton then
		ktButton:StripTextures()
		ktButton:StyleButton()
		ktButton:SetTemplate()
		ktButton.icon:SetDrawLayer('ARTWORK', -1)
		ktButton.icon:SetTexCoords()
		ktButton.icon:SetInside()
		if E.db.benikui.general.benikuiStyle and E.db.benikui.general.shadows then
			ktButton:CreateSoftShadow()
		end
	end

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
			local slider = widget.slider
			if slider and not slider.isSkinned then
				S:HandleSliderFrame(slider)
				slider.isSkinned = true
			end
		end)
	end
end
S:AddCallback("BenikUI_KalielsTracker", KalielsTracker)

---------------
-- LibDBIcon --
---------------
local function LibDBIcon()
	if BUI:IsAddOnEnabled('TipTac') then return end

	local DBIcon = LibStub("LibDBIcon-1.0", true)
	if DBIcon and DBIcon.tooltip and DBIcon.tooltip:IsObjectType('GameTooltip') then
		DBIcon.tooltip:HookScript("OnShow", function(self)
			if not self.style then
				self:BuiStyle()
			end
		end)
	end
end
S:AddCallback("BenikUI_LibDBIcon", LibDBIcon)

--------------------
-- Lib AceGUI-3.0 --
--------------------
local isHooked = {}
function mod:HookAceGUI()
	local AceGUI, minorVersion = LibStub("AceGUI-3.0", true)

	if AceGUI and minorVersion and not isHooked[minorVersion] then
		hooksecurefunc(AceGUI, "RegisterAsContainer", function(_, widget)
			if widget.type == "Frame" or widget.type == "Window" then
				if widget and not widget.isStyled then
					if widget.frame then
						widget.frame:BuiStyle()
						widget.isStyled = true
					end
				end
			end
		end)

		isHooked[minorVersion] = true
	end
end

function mod:AceGUI()
	mod:HookAceGUI()
	mod:RegisterEvent("ADDON_LOADED", "HookAceGUI")
end
S:AddCallback("BenikUI_AceGUI", mod.AceGUI)

-------------------------
-- MinimapButtonButton --
-------------------------
local function MinimapButtonButton()
	if not (BUI:IsAddOnEnabled('MinimapButtonButton') and E.db.benikui.skins.variousSkins.minimapbb and E.db.benikui.general.benikuiStyle) then return end

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

--------------------------------------
-- Skada | Based on Azilroka's skin --
--------------------------------------
local function SkadaSkin()
	if not (BUI:IsAddOnEnabled('Skada') and E.db.benikui.skins.variousSkins.skada) then return end

	hooksecurefunc(Skada.displays['bar'], 'ApplySettings', function(_, win)
		local skada = win.bargroup
		skada:SetTemplate("Transparent")
		if not E.db.benikui.general.benikuiStyle then return end

		skada:BuiStyle()
		skada.button:BuiStyle()
		if skada.button.style then
			skada.button.style:Hide()
		end

		if win.db.enabletitle then
			if skada.button.style then
				skada.button.style:Show()
			end
			skada.style:Hide()
		end
	end)
end
S:AddCallback("BenikUI_Skada", SkadaSkin)

------------
-- TomTom --
------------
local function TomTom()
	if not (BUI:IsAddOnEnabled('TomTom') and E.db.benikui.skins.variousSkins.tomtom) then return end

	local frameDropDown = _G.MyFrameDropDownBackdrop
	if frameDropDown then
		frameDropDown:StripTextures()
		frameDropDown:SetTemplate("Transparent")

		frameDropDown:BuiStyle()
	end

	local mapDropDown = _G.TomTomWorldMapDropdownBackdrop
	if mapDropDown then
		mapDropDown:StripTextures()
		mapDropDown:SetTemplate("Transparent")

		mapDropDown:BuiStyle()
	end

	local mapDropDown = _G.TomTomDropdownBackdrop
	if mapDropDown then --minimap dropdown
		mapDropDown:StripTextures()
		mapDropDown:SetTemplate("Transparent")

		mapDropDown:BuiStyle()
	end

	local tomTooltip = _G.TomTomTooltip
	if tomTooltip then
		tomTooltip:BuiStyle()
	end
end
S:AddCallback("BenikUI_TomTom", TomTom)