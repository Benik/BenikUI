local E, L, V, P, G = unpack(ElvUI);
local BTT = E:NewModule('BenikUI_Tooltip');
local BUI = E:GetModule('BenikUI');
local TT = E:GetModule('Tooltip')

local GameTooltip, GameTooltipStatusBar = _G["GameTooltip"], _G["GameTooltipStatusBar"]
local IsAddOnLoaded = IsAddOnLoaded

local function StyleTooltip()
	GameTooltip:Style('Outside')

	if IsAddOnLoaded('FreebTip') then
		GameTooltip.style:ClearAllPoints()
		GameTooltip.style:Point('TOPLEFT', GameTooltip, 'TOPLEFT', (E.PixelMode and 1 or 0), (E.PixelMode and -1 or 7))
		GameTooltip.style:Point('BOTTOMRIGHT', GameTooltip, 'TOPRIGHT', (E.PixelMode and -1 or 0), (E.PixelMode and -6 or 1))
	end
end

local function RecolorTooltipStyle(tt)
	local r, g, b = GameTooltipStatusBar:GetStatusBarColor()
	GameTooltip.style.color:SetVertexColor(r, g, b)
end

function BTT:Initialize()
	if E.db.bui.buiStyle ~= true then return end
	StyleTooltip()
	hooksecurefunc(TT, "GameTooltip_OnTooltipSetUnit", RecolorTooltipStyle)
end

E:RegisterModule(BTT:GetName())