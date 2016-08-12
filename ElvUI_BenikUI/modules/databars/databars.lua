local E, L, V, P, G = unpack(ElvUI);
local BDB = E:NewModule('BenikUI_databars', 'AceHook-3.0', 'AceEvent-3.0');
local LSM = LibStub('LibSharedMedia-3.0');

local UIFrameFadeIn, UIFrameFadeOut = UIFrameFadeIn, UIFrameFadeOut

local bars = {'experience', 'reputation', 'artifact', 'honor'}

function BDB:CreateNotifier(bar)
	bar.f = CreateFrame('Frame', nil, bar)
	bar.f:Size(2, 10)
	bar.f.txt = bar.f:CreateFontString(nil, 'OVERLAY')
	bar.f.arrow = bar.f:CreateFontString(nil, 'OVERLAY')
	bar.f.arrow:SetFont(LSM:Fetch("font", 'Bui Visitor1'), 10, 'MONOCHROMEOUTLINE')
	
	for _, barname in pairs(bars) do
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

function BDB:Initialize()
	self:LoadXP()
	self:LoadRep()
	self:LoadAF()
	self:LoadHonor()
	-- clean the old db
end

E:RegisterModule(BDB:GetName())