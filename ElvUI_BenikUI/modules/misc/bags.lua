local E, L, V, P, G = unpack(ElvUI);
local BUIB = E:NewModule('BuiBags', 'AceHook-3.0', 'AceEvent-3.0');
local B = E:GetModule('Bags')

local _G = _G
local pairs, ipairs = pairs, ipairs

local GetContainerNumSlots = GetContainerNumSlots

-- GLOBALS: hooksecurefunc, NUM_CONTAINER_FRAMES

local SPACING = (E.PixelMode and 1 or 5)
local BORDER = E.Border;

function BUIB:StyleBags()
	if _G["ElvUI_ContainerFrame"] then
		_G["ElvUI_ContainerFrame"]:Style('Outside', 'playerbags')
		_G["ElvUI_ContainerFrameContainerHolder"]:Style('Outside')
	end

	if _G["ElvUI_ContainerFrameContainerHolder"] then
		_G["ElvUI_ContainerFrameContainerHolder"]:Point('BOTTOMLEFT', _G["playerbags"], 'TOPLEFT', 0, SPACING + BORDER)
	end
end

function BUIB:OpenBankBags()
	if _G["ElvUI_BankContainerFrame"] then
		_G["ElvUI_BankContainerFrame"]:Style('Outside', 'playerbank')
		_G["ElvUI_BankContainerFrameContainerHolder"]:Style('Outside')
	end
	
	if _G["ElvUI_BankContainerFrameContainerHolder"] then
		_G["ElvUI_BankContainerFrameContainerHolder"]:Point('BOTTOMLEFT', _G["playerbank"], 'TOPLEFT', 0, SPACING + BORDER)
	end
end

function BUIB:SkinBlizzBags()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.bags ~= true or E.private.bags.enable then return end

	for i=1, NUM_CONTAINER_FRAMES, 1 do
		local container = _G['ContainerFrame'..i]
		if container.backdrop then
			container.backdrop:Style('Inside')
		end
	end
	if _G["BankFrame"] then
		_G["BankFrame"]:Style('Outside')
	end
end

function BUIB:AllInOneBags()
	self:StyleBags()
	self:RegisterEvent('BANKFRAME_OPENED', 'OpenBankBags')
end

function BUIB:UpdateCountPosition()
	if E.private.bags.enable ~= true then return; end
	
	local y = 0
	local x = 0
	if E.db.bags.countPosition == 'TOPLEFT' then
		y = -2
		x = 2
	elseif E.db.bags.countPosition == 'TOP' or E.db.bags.countPosition == 'TOPRIGHT' then
		y = -2
	elseif E.db.bags.countPosition == 'BOTTOMLEFT' then 
		y = 2
		x = 2
	elseif E.db.bags.countPosition == 'BOTTOM' or E.db.bags.countPosition == 'BOTTOMRIGHT' then
		y = 2
	elseif E.db.bags.countPosition == 'LEFT' then
		x = 2
	end

	for _, bagFrame in pairs(B.BagFrames) do
		for _, bagID in ipairs(bagFrame.BagIDs) do
			for slotID = 1, GetContainerNumSlots(bagID) do
				local slot = bagFrame.Bags[bagID][slotID]
				if slot and slot.Count then
					slot.Count:ClearAllPoints()
					slot.Count:Point(E.db.bags.countPosition, x, y);
				end
			end
		end
		if bagFrame.UpdateAllSlots then
			bagFrame:UpdateAllSlots()
		end
	end
end

function BUIB:Initialize()
	if E.db.benikui.general.benikuiStyle ~= true then return end
	self:AllInOneBags()
	self:SkinBlizzBags()
	self:UpdateCountPosition()
	
	hooksecurefunc(B, 'UpdateCountDisplay', BUIB.UpdateCountPosition)
end

E:RegisterModule(BUIB:GetName())

