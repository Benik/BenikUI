local BUI, E, L, V, P, G = unpack((select(2, ...)))
local BU = BUI:GetModule('Units');
local UF = E:GetModule('UnitFrames');
local LSM = E.LSM;

local _G = _G
local pairs, select = pairs, select

function BU:Configure_Power(frame)
	local power = frame.Power

	if frame.USE_POWERBAR then
		if frame.POWERBAR_DETACHED then
			if frame.POWER_VERTICAL then
				power:SetOrientation('VERTICAL')
			else
				power:SetOrientation('HORIZONTAL')
			end
			if power.backdrop.shadow then
				power.backdrop.shadow:Show()
			end
		else
			if power.backdrop.shadow then
				power.backdrop.shadow:Hide()
			end
		end
	end
end

-- Units
function BU:ChangeUnitPowerBarTexture()
	local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.textures.power)
	for _, frame in pairs(UF.units) do
		if frame.Power then
			frame.Power:SetStatusBarTexture(bar)
		end
	end
end

-- Raid
function BU:ChangeRaidPowerBarTexture()
	for i = 1, 3 do
		local header = _G['ElvUF_Raid'..i]
		local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.textures.power)
		for j = 1, header:GetNumChildren() do
			local group = select(j, header:GetChildren())

			for k = 1, group:GetNumChildren() do
				local unitbutton = select(k, group:GetChildren())
				if unitbutton and unitbutton.Power then
					unitbutton.Power:SetStatusBarTexture(bar)
				end
			end
		end
	end
end

-- Party
function BU:ChangePartyPowerBarTexture()
	local header = _G['ElvUF_Party']
	local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.textures.power)
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if unitbutton and unitbutton.Power then
				unitbutton.Power:SetStatusBarTexture(bar)
			end
		end
	end
end

-- Arena
function BU:ChangeArenaPowerBarTexture()
	local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.textures.power)
	for i = 1, 5 do
		local unitbutton = _G["ElvUF_Arena"..i]
		if unitbutton and unitbutton.Power then
			unitbutton.Power:SetStatusBarTexture(bar)
		end
	end
end

-- Boss
function BU:ChangeBossPowerBarTexture()
	local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.textures.power)
	for i = 1, 5 do
		local unitbutton = _G["ElvUF_Boss"..i]
		if unitbutton and unitbutton.Power then
			unitbutton.Power:SetStatusBarTexture(bar)
		end
	end
end

function BU:ChangePowerBarTexture()
	BU:ChangeUnitPowerBarTexture()
	BU:ChangeRaidPowerBarTexture()
	BU:ChangePartyPowerBarTexture()
	BU:ChangeArenaPowerBarTexture()
	BU:ChangeBossPowerBarTexture()
end
