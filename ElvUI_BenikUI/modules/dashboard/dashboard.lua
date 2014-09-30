--[[ Dashboard Plus for BenikUI
Credits : Sinaris, Elv
made for BenikUI under Sinaris permission. Big thanks :)
]]

local E, L, V, P, G, _ = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local BUID = E:NewModule('BuiDashboard')
local LSM = LibStub('LibSharedMedia-3.0')

if E.db.utils == nil then E.db.utils = {} end

local DASH_HEIGHT = 7
local DASH_WIDTH = E.db.utils.dwidth or 150
local DASH_NUM = 5
local DASH_SPACING = 3
local SPACING = (E.PixelMode and 1 or 5)

local function dholderOnFade()
	BuiDashboard:Hide()
end

-- Bar Holder
function BUID:CreateDashboardHolder()
	local dholder = CreateFrame('Frame', 'BuiDashboard', E.UIParent)
	dholder:CreateBackdrop('Transparent')
	dholder:Point('TOPLEFT', E.UIParent, 'TOPLEFT', 2, -30)
	dholder:SetFrameStrata('LOW')
	dholder:Size(DASH_WIDTH, ((DASH_HEIGHT+10)*DASH_NUM)+(DASH_SPACING*DASH_NUM) + DASH_SPACING)
	dholder.backdrop:Style('Outside')
	
	if E.db.utils.Scombat then
		dholder:SetScript('OnEvent',function(self, event)
			if event == 'PLAYER_REGEN_DISABLED' then
				UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
				self.fadeInfo.finishedFunc = dholderOnFade
			elseif event == 'PLAYER_REGEN_ENABLED' then
				UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
				self:Show()
			end	
		end)
	end

	E.FrameLocks['BuiDashboard'] = true;
	E:CreateMover(BuiDashboard, 'BuiDashboardMover', L['System'])
	self:EnableDisableCombat()
end

function BUID:EnableDisableCombat()
	if E.db.utils.Scombat then
		BuiDashboard:RegisterEvent('PLAYER_REGEN_DISABLED')
		BuiDashboard:RegisterEvent('PLAYER_REGEN_ENABLED')	
	else
		BuiDashboard:UnregisterEvent('PLAYER_REGEN_DISABLED')
		BuiDashboard:UnregisterEvent('PLAYER_REGEN_ENABLED')	
	end
end

BUID.board = {}
function BUID:HolderWidth()
	local DASH_WIDTH = E.db.utils.dwidth
	BuiDashboard:Width(DASH_WIDTH)
	for i = 1, DASH_NUM do
		BUID.board[i]:Width(DASH_WIDTH - 6)
		BUID.board[i].dummyf:Width(DASH_WIDTH - 6)
	end
end

function BUID:CreateBoards()
	for i = 1, DASH_NUM do
		BUID.board[i] = CreateFrame('Frame', nil, BuiDashboard)
		BUID.board[i]:Width(DASH_WIDTH - 6)
		BUID.board[i]:Height(3)
		
		if i == 1 then
			BUID.board[i]:Point('TOP', BuiDashboard, 'TOP', 0, -DASH_HEIGHT-(DASH_SPACING*3))
		else
			BUID.board[i]:Point('TOP', BUID.board[i-1], 'BOTTOM', 0, -(DASH_HEIGHT*2)-DASH_SPACING)
		end
		
		BUID.board[i].dummyf = CreateFrame('Frame', nil, BuiDashboard)
		BUID.board[i].dummyf:Width(DASH_WIDTH - 6)
		BUID.board[i].dummyf:Height(20)
		
		if i == 1 then
			BUID.board[i].dummyf:Point('TOP', BuiDashboard, 'TOP')
		else
			BUID.board[i].dummyf:Point('TOP', BUID.board[i-1].dummyf, 'BOTTOM')
		end
		
		BUID.board[i].dummy = BUID.board[i]:CreateTexture(nil, 'OVERLAY')
		BUID.board[i].dummy:SetInside()
		BUID.board[i].dummy:SetTexture(E['media'].BuiFlat)
		BUID.board[i].dummy:SetVertexColor(1, 1, 1, .2)
		
		BUID.board[i].Status = CreateFrame('StatusBar', nil, BUID.board[i])
		BUID.board[i].Status:SetInside()
		BUID.board[i].Status:SetStatusBarTexture(E['media'].BuiFlat)
		BUID.board[i].Status:SetMinMaxValues(0, 100)
		BUID.board[i].Status:SetStatusBarColor(1, 0.5, 0.1, 1)
		
		BUID.board[i].spark = BUID.board[i].Status:CreateTexture(nil, 'OVERLAY', nil);
		BUID.board[i].spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]]);
		BUID.board[i].spark:Size(12, 6);
		BUID.board[i].spark:SetBlendMode('ADD');
		BUID.board[i].spark:Point('CENTER', BUID.board[i].Status:GetStatusBarTexture(), 'RIGHT')	
		
		BUID.board[i].Text = BUID.board[i].Status:CreateFontString(nil, 'OVERLAY')
		BUID.board[i].Text:Point('BOTTOMLEFT', BUID.board[i], 'BOTTOMLEFT', 2, 4)
		BUID.board[i].Text:SetJustifyH('LEFT')
	end
	self:ChangeFont()
end

function BUID:ChangeFont()
	for i = 1, DASH_NUM do
		if E.db.utils.dtfont then
			BUID.board[i].Text:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
		else
			BUID.board[i].Text:FontTemplate(LSM:Fetch('font', E.db.utils.dbfont), E.db.utils.dbfontsize, E.db.utils.dbfontflags)
		end
	end
end

function BUID:Initialize()
	if E.db.utils.enableSystem ~= true then return end
	self:CreateDashboardHolder()
	self:CreateBoards()
	self:HolderWidth()
	self:CreateFps()
	self:CreateMs()
	self:CreateMemory()
	self:CreateDurability()
	self:CreateVolume()
end

E:RegisterModule(BUID:GetName())