local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Styles')
local S = E:GetModule('Skins')

local _G = _G
local hooksecurefunc = hooksecurefunc
local LibStub = _G.LibStub

------------
-- AceGUI --
------------
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

---------------------------------
-- LibDBIcon. Credit: Azilroka --
---------------------------------
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

-------------------------------
-- LibQTip. Credit: Azilroka --
-------------------------------
function mod:LibQTip()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.tooltip) then return end

	local LQT = LibStub("LibQTip-1.0", true)
	if LQT then
		S:SecureHook(LQT, 'Acquire', function()
			for _, tt in LQT:IterateTooltips() do
				tt:StripTextures()
				tt:SetTemplate("Transparent")
				tt:BuiStyle()
			end
		end)
	end

	local LQTRS = LibStub("LibQTip-1.0RS", true)
	if LQTRS then
		S:SecureHook(LQTRS, 'Acquire', function()
			for _, tt in LQTRS:IterateTooltips() do
				tt:StripTextures()
				tt:SetTemplate("Transparent")
				tt:BuiStyle()
			end
		end)
	end
end
S:AddCallback("BenikUI_LibQTip", mod.LibQTip)



