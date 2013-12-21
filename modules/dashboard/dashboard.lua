--[[ Dashboard Plus for BenikUI
Credits : Sinaris, Elv
made for BenikUI under Sinaris permission. Big thanks :)
]]

local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local LSM = LibStub("LibSharedMedia-3.0")

local DASH_HEIGHT = 7
local DASH_WIDTH = 150
local DASH_NUM = 5
local DASH_SPACING = 3
local SPACING = (E.PixelMode and 1 or 5)

-- Bar Holder
local dholder = CreateFrame('Frame', 'BenikDashboard', E.UIParent)
dholder:CreateBackdrop('Transparent')
dholder:Point('TOPLEFT', E.UIParent, 'TOPLEFT', 2, -30)
dholder:SetFrameStrata('LOW')
dholder:Size(DASH_WIDTH, ((DASH_HEIGHT+10)*DASH_NUM)+(DASH_SPACING*DASH_NUM) + DASH_SPACING)
--dholder:CreateSoftShadow('Default')
--dholder:Size(DASH_WIDTH, 300)
local dholderdecor = E:BenikStyle('DashboardDecor', BenikDashboard)
E.FrameLocks['BenikDashboard'] = true;
E:CreateMover(BenikDashboard, "BenikDashboardMover", L["Dashboard"]) -- temporary

board = {}
for i = 1, DASH_NUM do
	board[i] = CreateFrame('Frame', 'board'..i, dholder)
	board[i]:Size(DASH_WIDTH - 6, 3)
	
	if i == 1 then
		board[i]:Point('TOP', dholder, 'TOP', 0, -DASH_HEIGHT-(DASH_SPACING*3))
	else
		board[i]:Point('TOP', board[i-1], 'BOTTOM', 0, -(DASH_HEIGHT*2)-DASH_SPACING)
	end
	
	board[i].dummy = CreateFrame("StatusBar", "dummyStatus" .. i, board[i])
	board[i].dummy:SetInside()
	board[i].dummy:SetStatusBarTexture(E["media"].normTex)
	board[i].dummy:SetStatusBarColor(1, 1, 1, .2)
	
	board[i].Status = CreateFrame("StatusBar", "PanelStatus" .. i, board[i])
	board[i].Status:SetInside()
	board[i].Status:SetStatusBarTexture(E["media"].normTex)
	board[i].Status:SetMinMaxValues(0, 100)
	board[i].Status:SetStatusBarColor(1, 0.5, 0.1, 1)
	
	board[i].spark = board[i].Status:CreateTexture(nil, "OVERLAY", nil);
	board[i].spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]]);
	board[i].spark:SetSize(12, 6);
	board[i].spark:SetBlendMode("ADD");
	board[i].spark:SetPoint('CENTER', board[i].Status:GetStatusBarTexture(), 'RIGHT')	
	
	board[i].Text = board[i].Status:CreateFontString(nil, "OVERLAY")
	board[i].Text:FontTemplate()
	board[i].Text:Point("BOTTOMLEFT", board[i], "BOTTOMLEFT", 2, 4)
	board[i].Text:SetJustifyH('LEFT')
	board[i].Text:SetShadowColor(0, 0, 0)
	board[i].Text:SetShadowOffset(1.25, -1.25)
end
