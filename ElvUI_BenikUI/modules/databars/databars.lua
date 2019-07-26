local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:NewModule('BuiDatabars', 'AceHook-3.0', 'AceEvent-3.0');
local LSM = E.LSM;

local UIFrameFadeIn, UIFrameFadeOut = UIFrameFadeIn, UIFrameFadeOut
local SPACING = (E.PixelMode and 1 or 3)
local bars = {'experience', 'reputation', 'artifact', 'honor'}

function mod:CreateNotifier(bar)
	bar.f = CreateFrame('Frame', nil, bar)
	bar.f:Size(2, 10)
	bar.f.txt = bar.f:CreateFontString(nil, 'OVERLAY')
	bar.f.arrow = bar.f:CreateFontString(nil, 'OVERLAY')
	bar.f.arrow:SetFont(LSM:Fetch("font", 'Bui Visitor1'), 10, 'MONOCHROMEOUTLINE')

	for _, barname in pairs(bars) do
		if E.db.benikuiDatabars[barname] == nil then E.db.benikuiDatabars[barname] = {} end
		if E.db.benikuiDatabars[barname].notifiers == nil then E.db.benikuiDatabars[barname].notifiers = {} end

		if E.db.benikuiDatabars[barname].notifiers.combat then
			bar.f:RegisterEvent("PLAYER_REGEN_DISABLED")
			bar.f:RegisterEvent("PLAYER_REGEN_ENABLED")

			bar.f:SetScript("OnEvent",function(self, event)
				if event == "PLAYER_REGEN_DISABLED" then
					UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
					self:Hide()
				elseif event == "PLAYER_REGEN_ENABLED" then
					UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
					self:Show()
				end
			end)
		end
	end
end

function mod:StyleBar(bar, onClick)
	bar.fb = CreateFrame('Button', nil, bar)
	bar.fb:Point('TOPLEFT', bar, 'BOTTOMLEFT', 0, -SPACING)
	bar.fb:Point('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', 0, (E.PixelMode and -20 or -22))

	bar.fb:SetScript('OnClick', onClick)

	if BUI.ShadowMode then
		bar.fb:CreateSoftShadow()
		if not bar.style then
			bar:CreateSoftShadow()
		end
	end

	if E.db.benikui.general.benikuiStyle ~= true then return end
	bar:Style('Outside', nil, false, true)
end

function mod:Initialize()
	self:LoadXP()
	self:LoadRep()
	self:LoadAzerite()
	self:LoadHonor()
end

BUI:RegisterModule(mod:GetName())