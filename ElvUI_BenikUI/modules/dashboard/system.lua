--[[ Dashboard Plus for BenikUI
Credits : Sinaris, Elv
made for BenikUI under Sinaris permission. Big thanks :)
]]

local E, L, V, P, G, _ = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local BUID = E:NewModule('BuiDashboard')
local LSM = LibStub('LibSharedMedia-3.0')
local DT = E:GetModule('DataTexts')

local tinsert, twipe, getn, pairs, ipairs = table.insert, table.wipe, getn, pairs, ipairs

local CreateFrame = CreateFrame
local UIFrameFadeIn, UIFrameFadeOut = UIFrameFadeIn, UIFrameFadeOut

if E.db.dashboards == nil then E.db.dashboards = {} end
if E.db.dashboards.system == nil then E.db.dashboards.system = {} end

-- Defaults
V['BUID'] = {
	['warned'] = false,
}

local DASH_HEIGHT = 20
local DASH_WIDTH = E.db.dashboards.system.width or 150
local DASH_SPACING = 3
local SPACING = 1

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

local boards = {"FPS", "MS", "Memory", "Durability", "Volume"}
local loadedBoards = {}

local function dholderOnFade()
	sysHolder:Hide()
end

-- Bar Holder
function BUID:CreateSystemHolder()
	local sholder = CreateFrame('Frame', 'sysHolder', E.UIParent)
	sholder:CreateBackdrop('Transparent')
	sholder:Point('TOPLEFT', E.UIParent, 'TOPLEFT', 2, -30)
	sholder:SetFrameStrata('LOW')
	sholder:Width(DASH_WIDTH)
	sholder:Height(DASH_HEIGHT)
	sholder.backdrop:Style('Outside')
	
	if E.db.dashboards.system.combat then
		sholder:SetScript('OnEvent',function(self, event)
			if event == 'PLAYER_REGEN_DISABLED' then
				UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
				self.fadeInfo.finishedFunc = dholderOnFade
			elseif event == 'PLAYER_REGEN_ENABLED' then
				UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
				self:Show()
			end	
		end)
	end

	E.FrameLocks['sysHolder'] = true;
	E:CreateMover(sysHolder, 'BuiDashboardMover', L['System'])
	self:EnableDisableCombat()
	self:UpdateBoards()
end

function BUID:EnableDisableCombat()
	if E.db.dashboards.system.combat then
		sysHolder:RegisterEvent('PLAYER_REGEN_DISABLED')
		sysHolder:RegisterEvent('PLAYER_REGEN_ENABLED')	
	else
		sysHolder:UnregisterEvent('PLAYER_REGEN_DISABLED')
		sysHolder:UnregisterEvent('PLAYER_REGEN_ENABLED')	
	end
end

function BUID:UpdateSysHolderDimensions()
	sysHolder:Width(E.db.dashboards.system.width)

	for _, frame in pairs(loadedBoards) do
		frame:Width(E.db.dashboards.system.width)
	end
end

function BUID:UpdateBoards()
	local db = E.db.dashboards.system
	if( loadedBoards[1] ) then
		for i = 1, getn( loadedBoards ) do
			loadedBoards[i]:Kill()
		end
		twipe( loadedBoards )
		sysHolder.backdrop:Hide()
	end

	for _, name in pairs(boards) do
		if db.chooseSystem[name] == true then
			sysHolder.backdrop:Show()
			sysHolder:Height(((DASH_HEIGHT + (E.PixelMode and 1 or DASH_SPACING)) * (#loadedBoards + 1)) + DASH_SPACING)

			local sysFrame = CreateFrame('Frame', name, sysHolder)
			sysFrame:Height(DASH_HEIGHT)
			sysFrame:Width(DASH_WIDTH)
			sysFrame:Point('TOPLEFT', sysHolder, 'TOPLEFT', SPACING, -SPACING)
			sysFrame:EnableMouse(true)
			
			sysFrame.dummy = CreateFrame('Frame', nil, sysFrame)
			sysFrame.dummy:Point('BOTTOMLEFT', sysFrame, 'BOTTOMLEFT', 2, 2)
			sysFrame.dummy:Point('BOTTOMRIGHT', sysFrame, 'BOTTOMRIGHT', (E.PixelMode and -4 or -8), 0)
			sysFrame.dummy:Height(E.PixelMode and 3 or 5)

			sysFrame.dummy.dummyStatus = sysFrame.dummy:CreateTexture(nil, 'OVERLAY')
			sysFrame.dummy.dummyStatus:SetInside()
			sysFrame.dummy.dummyStatus:SetTexture(E['media'].BuiFlat)
			sysFrame.dummy.dummyStatus:SetVertexColor(1, 1, 1, .2)
			
			sysFrame.Status = CreateFrame('StatusBar', nil, sysFrame.dummy)
			sysFrame.Status:SetStatusBarTexture(E['media'].BuiFlat)
			sysFrame.Status:SetMinMaxValues(0, 100)
			sysFrame.Status:SetInside()
			
			sysFrame.spark = sysFrame.Status:CreateTexture(nil, 'OVERLAY', nil);
			sysFrame.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]]);
			sysFrame.spark:SetSize(12, 6);
			sysFrame.spark:SetBlendMode('ADD');
			sysFrame.spark:SetPoint('CENTER', sysFrame.Status:GetStatusBarTexture(), 'RIGHT')			
			
			sysFrame.Text = sysFrame.Status:CreateFontString(nil, 'OVERLAY')
			sysFrame.Text:Point('LEFT', sysFrame, 'LEFT', 6, (E.PixelMode and 2 or 3))
			sysFrame.Text:SetJustifyH('LEFT')

			tinsert(loadedBoards, sysFrame)
		end
	end

	for key, frame in ipairs(loadedBoards) do
		frame:ClearAllPoints()
		if(key == 1) then
			frame:Point( 'TOPLEFT', sysHolder, 'TOPLEFT', 0, -SPACING -(E.PixelMode and 0 or 4))
		else
			frame:Point('TOP', loadedBoards[key - 1], 'BOTTOM', 0, -SPACING -(E.PixelMode and 0 or 2))
		end
	end

end

function BUID:ChangeFont()
	for _, frame in pairs(loadedBoards) do
		if E.db.dashboards.dashfont.useDTfont then
			frame.Text:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
		else
			frame.Text:FontTemplate(LSM:Fetch('font', E.db.dashboards.dashfont.dbfont), E.db.dashboards.dashfont.dbfontsize, E.db.dashboards.dashfont.dbfontflags)
		end
	end
end

function BUID:FontColor()
	for _, frame in pairs(loadedBoards) do
		if E.db.dashboards.textColor == 1 then
			frame.Text:SetTextColor(classColor.r, classColor.g, classColor.b)
		else
			frame.Text:SetTextColor(BUI:unpackColor(E.db.dashboards.customTextColor))
		end
	end
end

function BUID:BarColor()
	for _, frame in pairs(loadedBoards) do
		frame.Status:SetStatusBarColor(E.db.dashboards.barColor.r, E.db.dashboards.barColor.g, E.db.dashboards.barColor.b)
	end
end

function BUID:Initialize()
	
	if E.db.dashboards.system.enableSystem ~= true then return end
	local db = E.db.dashboards.system.chooseSystem

	if (db.FPS ~= true and db.MS ~= true and db.Memory ~= true and db.Durability ~= true and db.Volume ~= true) then return end	

	self:CreateSystemHolder()
	hooksecurefunc(DT, 'LoadDataTexts', BUID.ChangeFont)
	self:FontColor()
	self:BarColor()
	
	if db.FPS then self:CreateFps() end
	if db.MS then self:CreateMs() end
	if db.Memory then self:CreateMemory() end
	if db.Durability then self:CreateDurability() end
	if db.Volume then self:CreateVolume() end
	if E.private.BUID.warned then E.private.BUID.warned = nil end -- delete the Zygor warn setting
end

E:RegisterModule(BUID:GetName())
