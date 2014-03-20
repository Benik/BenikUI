local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUIS = E:NewModule('BuiSkins', "AceHook-3.0");
local BUI = E:GetModule('BenikUI');

local SPACING = (E.PixelMode and 1 or 5)

-----------------------------------------------

local FreeBlizzFrames = {
	AudioOptionsFrame,
	BNToastFrame,
	ChatConfigFrame,
	ClassTrainerFrame,
	ConsolidatedBuffsTooltip, -- check
	ElvUI_StaticPopup1,
	ElvUI_StaticPopup2,
	ElvUI_StaticPopup3,
	FriendsFrame,
	GameMenuFrame,
	GossipFrame,
	GuildRegistrarFrame,
	InterfaceOptionsFrame,
	ItemRefTooltip,
	LFGDungeonReadyPopup,
	LFGDungeonReadyDialog,
	LFGDungeonReadyStatus,
	MailFrame,
	OpenMailFrame,
	PaperDollItemsFrame,
	PetitionFrame, -- check
	PetJournalParent,
	PetPaperDollFrame,
	PetStableFrame, -- check
	QuestLogDetailFrame,
	QuestLogFrame,
	QueueStatusFrame,
	RaidInfoFrame,
	ReadyCheckFrame,
	ReadyCheckListenerFrame,
	ReputationDetailFrame,
	ReputationFrame,
	SpellBookFrame,
	StackSplitFrame,
	StaticPopup1,
	StaticPopup2,
	StaticPopup3,
	TabardFrame,
	TicketStatusFrameButton, -- check
	TokenFrame,
	TradeFrame, -- check
	TransmogrifyConfirmationPopup,
	VideoOptionsFrame,
	--WorldMapFrame, -- checked not loading on big map, only small but decor shifts to the left
	WorldStateScoreScrollFrame, -- check

}

-- Style FreeBlizzFrames
local function ApplyStylesOnFreeBlizzFrames()

	for _, frame in pairs(FreeBlizzFrames) do
		if frame then
			frame:StyleSkins()
		end
	end
end

-------------------------------------
-- the style is smaller by 1-2 pixels
-------------------------------------
local FreeBlizzSmallerFrames = {
	HelpFrame,
	PVEFrame,
	QuestFrame,
	QuestNPCModel,
	RaidBrowserFrame,
	TaxiFrame,
}

-- Function to Style FreeBlizzSmallerFrames
local function StyleSmallerFrames(name, parent, ...)
	local frame = CreateFrame('Frame', name, E.UIParent)
	frame:CreateBackdrop('Default', true)
	frame:SetParent(parent)
	frame:Point('TOPLEFT', parent, 'TOPLEFT', 0, 6)
	frame:Point('BOTTOMRIGHT', parent, 'TOPRIGHT', 0, 1)
	
	return frame
end

-- Style FreeBlizzSmallerFrames
local function ApplyStylesOnBlizzSmallerFrames()

	for _, frame in pairs(FreeBlizzSmallerFrames) do
		if frame then
			StyleSmallerFrames(nil, frame)
		end
	end
end

---------------
-- Crazy Frames
---------------

-- DressUp Frame
local function dressupFrm()
	local df
	if not df then
		df = CreateFrame('Frame', nil, DressUpFrame)
		df:CreateBackdrop('Default', true)
		df:Point('TOPLEFT', DressUpFrame, 'TOPLEFT', 7, 5)
		df:Point('BOTTOMRIGHT', DressUpFrame, 'TOPRIGHT', -33, 0)
	end
end

-- Merchant Frame
local function merchantFrm()
	local mf
	if not mf then
		mf = CreateFrame('Frame', nil, MerchantFrame)
		mf:CreateBackdrop('Default', true)
		mf:Point('TOPLEFT', MerchantFrame, 'TOPLEFT', 7, 7)
		mf:Point('BOTTOMRIGHT', MerchantFrame, 'TOPRIGHT', SPACING, 2)
	end
end

------------------
-- Fixes/Additions
------------------

local function spellbk()
	for i = 1, MAX_SKILLLINE_TABS do
		local tab = _G["SpellBookSkillLineTab"..i]
		tab:StyleInFrame()
	end
end

----------------
-- Style Recount
----------------
local function StyleRecount(name, parent, ...)
	local frame = CreateFrame('Frame', name, E.UIParent)
	frame:SetTemplate('Default', true)
	frame:SetParent(parent)
	frame:Point('TOPLEFT', parent, 'TOPLEFT', 0, -SPACING)
	frame:Point('BOTTOMRIGHT', parent, 'TOPRIGHT', 0, -7)

	return frame
end

local recountFrame = CreateFrame("Frame")
recountFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
recountFrame:SetScript("OnEvent",function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		if IsAddOnLoaded("Recount") and IsAddOnLoaded("AddOnSkins_ElvUI") then
			Recount_MainWindow.TitleBackground:StripTextures()
			Recount_ConfigWindow.TitleBackground:StripTextures()
			StyleRecount(nil, Recount_ConfigWindow)
			hooksecurefunc(Recount, 'ShowReport', function(self)
				Recount_ReportWindow.TitleBackground:StripTextures()
				StyleRecount(nil, Recount_ReportWindow)
			end)
			Recount_DetailWindow.TitleBackground:StripTextures()
			StyleRecount(nil, Recount_DetailWindow)
		end
		recountFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end)

---------------
-- LocationPlus
---------------
local lpFrame = CreateFrame("Frame")
lpFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
lpFrame:SetScript("OnEvent",function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		if IsAddOnLoaded("ElvUI_LocPlus") then
			local framestoskin = {LeftCoordDtPanel, RightCoordDtPanel, LocationPlusPanel, XCoordsPanel, YCoordsPanel}
			for _, frame in pairs(framestoskin) do
				frame:StyleOnFrame()
			end
		end
		lpFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end)

---------------
-- LocationLite
---------------
local llFrame = CreateFrame("Frame")
llFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
llFrame:SetScript("OnEvent",function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		if IsAddOnLoaded("ElvUI_LocLite") then
			local framestoskin = {LocationLitePanel, XCoordsLite, YCoordsLite}
			for _, frame in pairs(framestoskin) do
				frame:StyleOnFrame()
			end
		end
		llFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end)

function BUIS:Initialize()
	ApplyStylesOnFreeBlizzFrames()
	ApplyStylesOnBlizzSmallerFrames()
	merchantFrm()
	dressupFrm()
	hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs", spellbk)
end

E:RegisterModule(BUIS:GetName())
