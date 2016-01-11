local E, L, V, P, G, _ = unpack(ElvUI);
local BUIB = E:NewModule('BuiBags', 'AceHook-3.0', 'AceEvent-3.0');
local B = E:GetModule('Bags')

local _G = _G

local SPACING = (E.PixelMode and 1 or 5)
local BORDER = E.Border;

function BUIB:StyleBags()
	if ElvUI_ContainerFrame then
		ElvUI_ContainerFrame:Style('Outside', 'playerbags')
		ElvUI_ContainerFrameContainerHolder:Style('Outside')
	end

	if ElvUI_ContainerFrameContainerHolder then
		ElvUI_ContainerFrameContainerHolder:Point('BOTTOMLEFT', playerbags, 'TOPLEFT', 0, SPACING + BORDER)
	end
end

function BUIB:OpenBankBags()
	if ElvUI_BankContainerFrame then
		ElvUI_BankContainerFrame:Style('Outside', 'playerbank')
		ElvUI_BankContainerFrameContainerHolder:Style('Outside')
	end
	
	if ElvUI_BankContainerFrameContainerHolder then
		ElvUI_BankContainerFrameContainerHolder:Point('BOTTOMLEFT', playerbank, 'TOPLEFT', 0, SPACING + BORDER)
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
	if BankFrame then
		BankFrame:Style('Outside')
	end
end

function BUIB:AllInOneBags()
	self:StyleBags()
	self:RegisterEvent('BANKFRAME_OPENED', 'OpenBankBags')
end

function BUIB:UpdateCountPosition()
	if E.private.bags.enable ~= true then return; end

	for _, bagFrame in pairs(B.BagFrames) do
		for _, bagID in ipairs(bagFrame.BagIDs) do
			for slotID = 1, GetContainerNumSlots(bagID) do
				local slot = bagFrame.Bags[bagID][slotID]
				if slot and slot.Count then
					slot.Count:ClearAllPoints()
					slot.Count:Point(E.db.bags.countPosition, 0, 0);
				end
			end
		end
		if bagFrame.UpdateAllSlots then
			bagFrame:UpdateAllSlots()
		end
	end
end

function BUIB:Initialize()
	if E.db.bui.buiStyle ~= true then return end
	self:AllInOneBags()
	self:SkinBlizzBags()
	self:UpdateCountPosition()
	
	hooksecurefunc(B, 'UpdateCountDisplay', BUIB.UpdateCountPosition)
end

E:RegisterModule(BUIB:GetName())

