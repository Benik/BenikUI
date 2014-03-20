--[[ Dashboard Plus for BenikUI
Credits : Sinaris, Elv
made for BenikUI under Sinaris permission. Big thanks :)
]]

local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
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
	dholder:Style()
	E.FrameLocks['BuiDashboard'] = true;
	E:CreateMover(BuiDashboard, "BuiDashboardMover", L["Dashboard"]) -- temporary
end

dboard = {}
function BUID:HolderWidth()
	local DASH_WIDTH = E.db.utils.dwidth
	BuiDashboard:Width(DASH_WIDTH)
	for i = 1, DASH_NUM do
		dboard[i]:Width(DASH_WIDTH - 6)
		dboard[i].dummyf:Width(DASH_WIDTH - 6)
	end
end

function BUID:CreateBoards()
	for i = 1, DASH_NUM do
		dboard[i] = CreateFrame('Frame', 'dboard'..i, BuiDashboard)
		dboard[i]:Width(DASH_WIDTH - 6)
		dboard[i]:Height(3)
		
		if i == 1 then
			dboard[i]:Point('TOP', BuiDashboard, 'TOP', 0, -DASH_HEIGHT-(DASH_SPACING*3))
		else
			dboard[i]:Point('TOP', dboard[i-1], 'BOTTOM', 0, -(DASH_HEIGHT*2)-DASH_SPACING)
		end
		
		dboard[i].dummyf = CreateFrame("Frame", "dummyFrame" .. i, BuiDashboard)
		dboard[i].dummyf:Width(DASH_WIDTH - 6)
		dboard[i].dummyf:Height(20)
		
		if i == 1 then
			dboard[i].dummyf :Point('TOP', BuiDashboard, 'TOP')
		else
			dboard[i].dummyf :Point('TOP', dboard[i-1].dummyf, 'BOTTOM')
		end
		
		dboard[i].dummy = dboard[i]:CreateTexture(nil, 'OVERLAY')
		dboard[i].dummy:SetInside()
		dboard[i].dummy:SetTexture(E["media"].BuiFlat)
		dboard[i].dummy:SetVertexColor(1, 1, 1, .2)
		
		dboard[i].Status = CreateFrame("StatusBar", nil, dboard[i])
		dboard[i].Status:SetInside()
		dboard[i].Status:SetStatusBarTexture(E["media"].BuiFlat)
		dboard[i].Status:SetMinMaxValues(0, 100)
		dboard[i].Status:SetStatusBarColor(1, 0.5, 0.1, 1)
		
		dboard[i].spark = dboard[i].Status:CreateTexture(nil, "OVERLAY", nil);
		dboard[i].spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]]);
		dboard[i].spark:Size(12, 6);
		dboard[i].spark:SetBlendMode("ADD");
		dboard[i].spark:Point('CENTER', dboard[i].Status:GetStatusBarTexture(), 'RIGHT')	
		
		dboard[i].Text = dboard[i].Status:CreateFontString(nil, "OVERLAY")
		dboard[i].Text:FontTemplate(LSM:Fetch("font", E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
		dboard[i].Text:Point("BOTTOMLEFT", dboard[i], "BOTTOMLEFT", 2, 4)
		dboard[i].Text:SetJustifyH('LEFT')
		dboard[i].Text:SetShadowColor(0, 0, 0)
		dboard[i].Text:SetShadowOffset(1.25, -1.25)
	end
end

function BUID:Initialize()
	self:CreateDashboardHolder()
	self:CreateBoards()
	self:HolderWidth()
	--self:InitTokens()
	self:CreateFps()
	self:CreateMs()
	self:CreateMemory()
	self:CreateDurability()
	self:CreateVolume()
end

E:RegisterModule(BUID:GetName())