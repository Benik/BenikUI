local E, L, V, P, G = unpack(ElvUI);
local DT = E:GetModule('DataTexts')

local strjoin = strjoin

local ShowGarrisonLandingPage = ShowGarrisonLandingPage
local C_CurrencyInfo_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local C_Covenants_GetCovenantData = C_Covenants.GetCovenantData
local C_Covenants_GetActiveCovenantID = C_Covenants.GetActiveCovenantID
local LE_GARRISON_TYPE_9_0 = Enum.GarrisonType.Type_9_0

local RenownID = 1822
local totalMax

local displayString, lastPanel = ''

local function GetTokenInfo(id)
	local info = C_CurrencyInfo_GetCurrencyInfo(id)
	if info then
		return info.name, info.quantity
	else
		return
	end
end

local function OnClick()
	if InCombatLockdown() then _G.UIErrorsFrame:AddMessage(E.InfoColor.._G.ERR_NOT_IN_COMBAT) return end
	if C_Covenants_GetCovenantData(C_Covenants_GetActiveCovenantID()) then
		HideUIPanel(_G.GarrisonLandingPage)
		ShowGarrisonLandingPage(LE_GARRISON_TYPE_9_0)
	end
end

local function OnEvent(self)
	local name, amount = GetTokenInfo(RenownID)
	if C_Covenants_GetCovenantData(C_Covenants_GetActiveCovenantID()) then
		amount = amount + 1
		totalMax = 80
	else
		amount = "-"
		totalMax = "-"
	end

	self.text:SetFormattedText(displayString, name, amount, totalMax)

	lastPanel = self
end

local function ValueColorUpdate(hex)
	displayString = strjoin('', '%s: ', hex, '%s/%s|r')

	if lastPanel then OnEvent(lastPanel) end
end

E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext('Renown (BenikUI)', 'BenikUI', {'COVENANT_SANCTUM_RENOWN_LEVEL_CHANGED'}, OnEvent, nil, OnClick)