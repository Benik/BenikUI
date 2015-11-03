local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local AB = E:GetModule('ActionBars');
local BAB = E:NewModule('BuiActionbars', 'AceEvent-3.0');

if E.private.actionbar.enable ~= true then return; end

local classColor = RAID_CLASS_COLORS[E.myclass]

local color = { r = 1, g = 1, b = 1 }
local function unpackColor(color)
	return color.r, color.g, color.b
end

if E.db.bab == nil then E.db.bab = {} end

local styleOtherBacks = {ElvUI_BarPet, ElvUI_StanceBar, ElvUI_TotemBar, BuiABbutton_1, BuiABbutton_2}

function BAB:StyleBackdrops()
	-- Actionbar backdrops
	for i = 1, 10 do
		local styleBacks = {_G['ElvUI_Bar'..i]}
		for _, frame in pairs(styleBacks) do
			if frame.backdrop then
				frame.backdrop:Style('Outside', frame:GetName()..'_Bui', true)
			end
		end
	end
	
	-- Other bar backdrops
	for _, frame in pairs(styleOtherBacks) do
		if frame.backdrop then
			frame.backdrop:Style('Outside', frame:GetName()..'_Bui', true)
		end
	end
end

function BAB:ColorBackdrops()
	if E.db.bui.buiStyle ~= true then return end
	for i = 1, 10 do
		local styleBacks = {_G['ElvUI_Bar'..i..'_Bui']}
		for _, frame in pairs(styleBacks) do
			frame.backdropTexture:SetTexture(E['media'].BuiFlat)
			if E.db.bui.abStyleColor == 1 then
				frame.backdropTexture:SetVertexColor(classColor.r, classColor.g, classColor.b)
			elseif E.db.bui.abStyleColor == 2 then
				frame.backdropTexture:SetVertexColor(unpackColor(E.db.bui.customAbStyleColor))
			elseif E.db.bui.abStyleColor == 3 then
				frame.backdropTexture:SetVertexColor(unpackColor(E.db.general.valuecolor))
			else
				frame.backdropTexture:SetVertexColor(unpackColor(E.db.general.backdropcolor))
			end
		end
	end
	
	for _, frame in pairs(styleOtherBacks) do
		local name = _G[frame:GetName()..'_Bui']
		name.backdropTexture:SetTexture(E['media'].BuiFlat)
		if E.db.bui.abStyleColor == 1 then
			name.backdropTexture:SetVertexColor(classColor.r, classColor.g, classColor.b)
		elseif E.db.bui.abStyleColor == 2 then
			name.backdropTexture:SetVertexColor(unpackColor(E.db.bui.customAbStyleColor))
		elseif E.db.bui.abStyleColor == 3 then
			name.backdropTexture:SetVertexColor(unpackColor(E.db.general.valuecolor))
		else
			name.backdropTexture:SetVertexColor(unpackColor(E.db.general.backdropcolor))
		end
	end
end

-- from ElvUI_TrasparentBackdrops plugin
function BAB:TransparentBackdrops()
	-- Actionbar backdrops
	for i = 1, 10 do
		local transBars = {_G['ElvUI_Bar'..i]}
		for _, frame in pairs(transBars) do
			if frame.backdrop then
				if E.db.bab.transBack then
					frame.backdrop:SetTemplate('Transparent')
				else
					frame.backdrop:SetTemplate('Default')
				end
			end
		end	
		
		-- Buttons
		for k = 1, 12 do
			local buttonBars = {_G['ElvUI_Bar'..i..'Button'..k]}
			for _, button in pairs(buttonBars) do
				if button.backdrop then
					if E.db.bab.transBack then
						button.backdrop:SetTemplate('Transparent')
					else
						button.backdrop:SetTemplate('Default', true)
					end
				end
			end
		end	
	end

	-- Other bar backdrops
	local transOtherBars = {ElvUI_BarPet, ElvUI_StanceBar, ElvUI_TotemBar, ElvUIBags}
	for _, frame in pairs(transOtherBars) do
		if frame.backdrop then
			if E.db.bab.transBack then
				frame.backdrop:SetTemplate('Transparent')
			else
				frame.backdrop:SetTemplate('Default')
			end
		end
	end
	
	-- Pet Buttons
	for i=1, NUM_PET_ACTION_SLOTS do
		local petButtons = {_G['PetActionButton'..i]}
		for _, button in pairs(petButtons) do
			if button.backdrop then
				if E.db.bab.transBack then
					button.backdrop:SetTemplate('Transparent')
				else
					button.backdrop:SetTemplate('Default', true)
				end
			end
		end
	end
end

function BAB:Initialize()
	-- Adding a small delay, because ElvUI_ExtraActionBars addon loads before BAB initialize
	C_Timer.After(1, BAB.StyleBackdrops)
	C_Timer.After(1, BAB.TransparentBackdrops)
	C_Timer.After(2, BAB.ColorBackdrops)
	--self:LoadToggleButtons()
	C_Timer.After(2, BAB.LoadToggleButtons)
	self:LoadRequestButton()
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", "ColorBackdrops");
	if IsAddOnLoaded('ElvUI_TB') then DisableAddOn('ElvUI_TB') end
end

E:RegisterModule(BAB:GetName())