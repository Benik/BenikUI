--[[ Dashboard Plus for BenikUI
Credits : Sinaris, Elv
made for BenikUI under Sinaris permission. Big thanks :)
]]

local E, L, V, P, G, _ = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local BUID = E:NewModule('BuiDashboard')
local LSM = LibStub("LibSharedMedia-3.0")

if E.db.utils == nil then E.db.utils = {} end
if E.db.utils.dwidth == nil then E.db.utils.dwidth = 150 end

local DASH_HEIGHT = 7
local DASH_WIDTH = E.db.utils.dwidth
local DASH_NUM = 5
local DASH_SPACING = 3
local SPACING = (E.PixelMode and 1 or 5)

-- Bar Holder
function BUID:CreateDashboardHolder()
	local dholder = CreateFrame('Frame', 'BuiDashboard', E.UIParent)
	dholder:CreateBackdrop('Transparent')
	dholder:Point('TOPLEFT', E.UIParent, 'TOPLEFT', 2, -30)
	dholder:SetFrameStrata('LOW')
	dholder:Size(DASH_WIDTH, ((DASH_HEIGHT+10)*DASH_NUM)+(DASH_SPACING*DASH_NUM) + DASH_SPACING)
	dholder.backdrop:Style('Outside')
	E.FrameLocks['BuiDashboard'] = true;
	E:CreateMover(BuiDashboard, "BuiDashboardMover", L["Dashboard"])
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
		
		BUID.board[i].dummyf = CreateFrame("Frame", nil, BuiDashboard)
		BUID.board[i].dummyf:Width(DASH_WIDTH - 6)
		BUID.board[i].dummyf:Height(20)
		
		if i == 1 then
			BUID.board[i].dummyf:Point('TOP', BuiDashboard, 'TOP')
		else
			BUID.board[i].dummyf:Point('TOP', BUID.board[i-1].dummyf, 'BOTTOM')
		end
		
		BUID.board[i].dummy = BUID.board[i]:CreateTexture(nil, 'OVERLAY')
		BUID.board[i].dummy:SetInside()
		BUID.board[i].dummy:SetTexture(E["media"].BuiFlat)
		BUID.board[i].dummy:SetVertexColor(1, 1, 1, .2)
		
		BUID.board[i].Status = CreateFrame("StatusBar", nil, BUID.board[i])
		BUID.board[i].Status:SetInside()
		BUID.board[i].Status:SetStatusBarTexture(E["media"].BuiFlat)
		BUID.board[i].Status:SetMinMaxValues(0, 100)
		BUID.board[i].Status:SetStatusBarColor(1, 0.5, 0.1, 1)
		
		BUID.board[i].spark = BUID.board[i].Status:CreateTexture(nil, "OVERLAY", nil);
		BUID.board[i].spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]]);
		BUID.board[i].spark:Size(12, 6);
		BUID.board[i].spark:SetBlendMode("ADD");
		BUID.board[i].spark:Point('CENTER', BUID.board[i].Status:GetStatusBarTexture(), 'RIGHT')	
		
		BUID.board[i].Text = BUID.board[i].Status:CreateFontString(nil, "OVERLAY")
		BUID.board[i].Text:FontTemplate(LSM:Fetch("font", E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
		BUID.board[i].Text:Point("BOTTOMLEFT", BUID.board[i], "BOTTOMLEFT", 2, 4)
		BUID.board[i].Text:SetJustifyH('LEFT')
	end
end

function BUID:Initialize()
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