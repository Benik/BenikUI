local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local ElvUF = ElvUI.oUF

function UFB:ConstructPartyPortraits()
	for _, header in pairs(UF.headers) do
		local headername = header:GetName()
		if headername == 'ElvUF_Party' then
			for i = 1, header:GetNumChildren() do
				local group = select(i, header:GetChildren())
				for j = 1, group:GetNumChildren() do
					local unitbutton = select(j, group:GetChildren())
					local unitbuttonname = unitbutton:GetName()
					unitbutton.Portrait3D = UF:Construct_Portrait(unitbutton, 'model')
					unitbutton.Portrait2D = UF:Construct_Portrait(unitbutton, 'texture')
				end
			end
		end
	end
	
	UF:UpdateAllHeaders()
end

function UFB:Update_PartyFrames(frame, db)
	--local db = E.db['unitframe']['units'].party
	frame.db = db
	if frame.Portrait then
		frame.Portrait:Hide()
		frame.Portrait:ClearAllPoints()
		frame.Portrait.backdrop:Hide()
	end
	frame.Portrait = db.portrait.style == '2D' and frame.Portrait2D or frame.Portrait3D

	local BORDER = E.Border;
	local SPACING = E.Spacing;
	local USE_POWERBAR = db.power.enable
	local USE_INSET_POWERBAR = db.power.width == 'inset' and USE_POWERBAR
	local USE_MINI_POWERBAR = db.power.width == 'spaced' and USE_POWERBAR
	local USE_POWERBAR_OFFSET = db.power.offset ~= 0 and USE_POWERBAR

	local USE_PORTRAIT = db.portrait.enable
	local USE_PORTRAIT_OVERLAY = db.portrait.overlay and USE_PORTRAIT
	local PORTRAIT_WIDTH = db.portrait.width
	
	--Adjust some variables
	do
		if USE_PORTRAIT_OVERLAY or not USE_PORTRAIT then
			PORTRAIT_WIDTH = 0
		end
	end
	
	if not frame.isChild then
		
		-- Health
		do
			local health = frame.Health
			
			health.bg:ClearAllPoints()
			if not USE_PORTRAIT_OVERLAY then
				health:Point("TOPLEFT", PORTRAIT_WIDTH+BORDER, -BORDER)
				health.bg:SetParent(health)
				health.bg:SetAllPoints()
			else
				health.bg:Point('BOTTOMLEFT', health:GetStatusBarTexture(), 'BOTTOMRIGHT')
				health.bg:Point('TOPRIGHT', health)
				health.bg:SetParent(frame.Portrait.overlay)
			end
		end
		
		-- Portrait
		do
			local portrait = frame.Portrait

			if USE_PORTRAIT then
				if not frame:IsElementEnabled('Portrait') then
					frame:EnableElement('Portrait')
				end
				portrait:ClearAllPoints()

				if USE_PORTRAIT_OVERLAY then
					if db.portrait.style == '3D' then
						portrait:SetFrameLevel(frame.Health:GetFrameLevel() + 1)
					end
					portrait:SetAllPoints(frame.Health)
					portrait:SetAlpha(0.3)
					portrait:Show()
					portrait.backdrop:Hide()
				else
					portrait:SetAlpha(1)
					portrait:Show()
					portrait.backdrop:Show()
					portrait.backdrop:ClearAllPoints()
					portrait.backdrop:Point("TOPLEFT", frame, "TOPLEFT")
					if db.portrait.style == '3D' then
						portrait:SetFrameLevel(frame:GetFrameLevel() + 5)
					end

					if USE_MINI_POWERBAR or USE_POWERBAR_OFFSET or not USE_POWERBAR or USE_INSET_POWERBAR then
						portrait.backdrop:Point("BOTTOMRIGHT", frame.Health.backdrop, "BOTTOMLEFT", E.PixelMode and -1 or SPACING, 0)
					else
						portrait.backdrop:Point("BOTTOMRIGHT", frame.Power.backdrop, "BOTTOMLEFT", E.PixelMode and -1 or SPACING, 0)
					end

					portrait:Point('BOTTOMLEFT', portrait.backdrop, 'BOTTOMLEFT', BORDER, BORDER)
					portrait:Point('TOPRIGHT', portrait.backdrop, 'TOPRIGHT', -BORDER, -BORDER)
				end
			else
				if frame:IsElementEnabled('Portrait') then
					frame:DisableElement('Portrait')
					portrait:Hide()
					portrait.backdrop:Hide()
				end
			end
		end
	end
	frame:UpdateAllElements()
end
