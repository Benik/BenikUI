local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUIB = E:NewModule('BuiBags', "AceHook-3.0", 'AceEvent-3.0');
local BUI = E:GetModule('BenikUI');
local B = E:GetModule('Bags')
local SPACING = (E.PixelMode and 1 or 5)
local BORDER = E.Border;

function BUIB:StyleBags()
	ElvUI_ContainerFrame:Style('Outside', 'playerbags')
	ElvUI_ContainerFrameContainerHolder:Style('Outside')
	
	if ElvUI_ContainerFrameContainerHolder then
		ElvUI_ContainerFrameContainerHolder:Point('BOTTOMLEFT', playerbags, 'TOPLEFT', 0, SPACING + BORDER)
	end
end

function BUIB:OpenBankBags()
	ElvUI_BankContainerFrame:Style('Outside', 'playerbank')
	ElvUI_BankContainerFrameContainerHolder:Style('Outside')
	
	if ElvUI_BankContainerFrameContainerHolder then
		ElvUI_BankContainerFrameContainerHolder:Point('BOTTOMLEFT', playerbank, 'TOPLEFT', 0, SPACING + BORDER)
	end
end

function BUIB:SkinBlizzBags()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.bags ~= true or E.private.bags.enable then return end

	for i=1, NUM_CONTAINER_FRAMES, 1 do
		local container = _G["ContainerFrame"..i]
		if container.backdrop then
			container.backdrop:Style('Inside')
		end
	end
	if BankFrame then
		BankFrame:Style('Outside')
	end
end

function BUIB:AllInOneBags()
	if E.private.bags.enable ~= true then return; end
	self:StyleBags()
	self:RegisterEvent("BANKFRAME_OPENED", "OpenBankBags")
end

function BUIB:Initialize()
	self:AllInOneBags()
	self:SkinBlizzBags()
end

E:RegisterModule(BUIB:GetName())

