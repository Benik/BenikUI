local BUI, E, L, V, P, G = unpack(select(2, ...))

-- GLOBALS: BenikUISplashScreen

local C_TimerAfter = C_Timer.After
local C_Calendar_GetDate = C_Calendar.GetDate

local function HideSplashScreen()
	BenikUISplashScreen:Hide()
end

local function FadeSplashScreen()
	E:Delay(2, function()
		E:UIFrameFadeOut(BenikUISplashScreen, 2, 1, 0)
		BenikUISplashScreen.fadeInfo.finishedFunc = HideSplashScreen
	end)
end

local function ShowSplashScreen()
	E:UIFrameFadeIn(BenikUISplashScreen, 4, 0, 1)
	BenikUISplashScreen.fadeInfo.finishedFunc = FadeSplashScreen
end

local function CreateSplashScreen()
	local f = CreateFrame('Frame', 'BenikUISplashScreen', E.UIParent)
	f:Size(300, 150)
	f:SetPoint('CENTER')
	f:SetFrameStrata('TOOLTIP')
	f:SetAlpha(0)

	f.bg = f:CreateTexture(nil, 'BACKGROUND')
	f.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
	f.bg:SetPoint('BOTTOM')
	f.bg:Size(400, 200)
	f.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
	f.bg:SetVertexColor(1, 1, 1, 0.7)

	f.lineTop = f:CreateTexture(nil, 'BACKGROUND')
	f.lineTop:SetDrawLayer('BACKGROUND', 2)
	f.lineTop:SetTexture([[Interface\LevelUp\LevelUpTex]])
	f.lineTop:SetPoint("TOP")
	f.lineTop:Size(418, 7)
	f.lineTop:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

	f.lineBottom = f:CreateTexture(nil, 'BACKGROUND')
	f.lineBottom:SetDrawLayer('BACKGROUND', 2)
	f.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
	f.lineBottom:SetPoint("BOTTOM")
	f.lineBottom:Size(418, 7)
	f.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

	f.logo = f:CreateTexture(nil, 'OVERLAY')
	f.logo:Size(384, 96)
	f.logo:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\logo_benikui.tga')
	f.logo:Point('CENTER', f, 'CENTER')

	f.version = f:CreateFontString(nil, 'OVERLAY')
	f.version:FontTemplate(nil, 12, nil)
	f.version:Point('TOP', f.logo, 'BOTTOM')
	f.version:SetFormattedText("v%s", BUI.Version)
end

function BUI:SplashScreen()
	if not E.db.benikui.general.splashScreen then return end
	CreateSplashScreen()

	local db = E.private.benikui.session
	local date = C_Calendar_GetDate()
	local presentWeekday = date.weekday;

	if presentWeekday == db.day then return end

	-- Show Splash Screen only if the install is completed
	if E.db.benikui.installed == true then C_TimerAfter(6, ShowSplashScreen) end
	db.day = presentWeekday
end