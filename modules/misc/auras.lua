local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local A = E:GetModule('Auras')
local BUI = E:GetModule('BenikUI');
local LSM = LibStub("LibSharedMedia-3.0")

if E.private.auras.enable ~= true then return end

-- Credits: Blazeflack (changes are based on his plugin ElvUI_VisualAuraTimers)

A.CreateIconBui = A.CreateIcon
function A:CreateIcon(button)
	self:CreateIconBui(button)
	
	button:StyleInFrame('decor')
	button.time:SetShadowColor(0, 0, 0)
	button.time:SetShadowOffset(1.25, -1.25)
	button.count:SetShadowColor(0, 0, 0)
	button.count:SetShadowOffset(1.25, -1.25)
	
	local Bar = CreateFrame('StatusBar', nil, decor)
	Bar:SetInside(decor)
	Bar:SetStatusBarTexture(E['media'].blankTex)
	Bar:SetStatusBarColor(0, 0.8, 0)
	button.Bar = Bar

end

A.UpdateAuraBui = A.UpdateAura
function A:UpdateAura(button, index)
	self:UpdateAuraBui(button, index)
	local filter = button:GetParent():GetAttribute('filter')
	local unit = button:GetParent():GetAttribute("unit")
	local name, rank, texture, count, dtype, duration, expirationTime, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff = UnitAura(unit, index, filter)

	if(name) then
		if(duration > 0 and expirationTime) then
			local timeLeft = expirationTime - GetTime()
			if(not button.timeLeft) then
				button.timeLeft = timeLeft
				button:SetScript("OnUpdate", A.UpdateTime)
			else
				button.timeLeft = timeLeft
			end

			button.nextUpdate = -1
			A.UpdateTime(button, 0)
		else
			button.timeLeft = nil
			button.time:SetText("")
			button:SetScript("OnUpdate", nil)			
		end

		if(count > 1) then
			button.count:SetText(count)
		else
			button.count:SetText("")
		end		

		if filter == "HARMFUL" then
			local color = DebuffTypeColor[dtype or ""]
			button:SetBackdropBorderColor(unpack(E.media.bordercolor))
			button.Bar:SetStatusBarColor(color.r, color.g, color.b)
			--button.decor:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			button:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
		
		-- Set min / max values
		if (button.Bar and duration > 0 and expirationTime) then
			button.Bar:SetMinMaxValues(0, duration)
		else
			-- Make sure a full statusbar is shown if aura has no duration
			local min, max  = button.Bar:GetMinMaxValues()
			button.Bar:SetValue(max)
			button.Bar:SetStatusBarColor(0, 0, 0)
		end

		button.texture:SetTexture(texture)
		button.texture:SetTexCoord(unpack(BUI.TexCoords))
		button.offset = nil
	end
	
	-- Set color and value of statusbar
	local timeLeft = button.timeLeft
	if not timeLeft then
		button.Bar:SetStatusBarColor(0, 0, 0, 0)
	else
	local r, g, b
		button.Bar:SetValue(timeLeft)
		r, g, b = ElvUF.ColorGradient(timeLeft, duration or 0, 0.8,0,0,0.8,0.8,0,0,0.8,0)
		button.Bar:SetStatusBarColor(r, g, b)
	end
end

A.UpdateHeaderBui = A.UpdateHeader
function A:UpdateHeader(header)
	self:UpdateHeaderBui(header)
	if(not E.private.auras.enable) then return end
	local db = self.db.debuffs
	if header:GetAttribute('filter') == 'HELPFUL' then
		db = self.db.buffs
		header:SetAttribute("consolidateTo", self.db.consolidatedBuffs.enable == true and E.private.general.minimap.enable == true and 1 or 0)
		header:SetAttribute('weaponTemplate', ("ElvUIAuraTemplate%d"):format(db.size))
	end
	local index = 1
	local child = select(index, header:GetChildren())
	while(child) do
		if((floor(child:GetWidth() * 100 + 0.5) / 100) ~= db.size-4) then
			child:SetSize(db.size, db.size-4)
		end

		if(child.time) then
			local font = LSM:Fetch("font", self.db.font)
			child.time:ClearAllPoints()
			child.time:SetPoint("TOP", child, 'BOTTOM', 1 + self.db.timeXOffset, 0 + self.db.timeYOffset)
			child.time:FontTemplate(font, self.db.fontSize, self.db.fontOutline)

			child.count:ClearAllPoints()
			child.count:SetPoint("BOTTOMRIGHT", -1 + self.db.countXOffset, 0 + self.db.countYOffset)
			child.count:FontTemplate(font, self.db.fontSize, self.db.fontOutline)
		end
		
		--Blizzard bug fix, icons arent being hidden when you reduce the amount of maximum buttons
		if(index > (db.maxWraps * db.wrapAfter) and child:IsShown()) then
			child:Hide()
		end

		index = index + 1
		child = select(index, header:GetChildren())
	end
end

A.UpdateTempEnchantBui = A.UpdateTempEnchant
function A:UpdateTempEnchant(button, index)
	self:UpdateTempEnchantBui(button, index)
	local quality = GetInventoryItemQuality("player", index)
	if(quality) then
		button:SetBackdropBorderColor(unpack(E.media.bordercolor))
		--button.decor:SetBackdropBorderColor(GetItemQualityColor(quality))
		button.Bar:SetStatusBarColor(GetItemQualityColor(quality))
	end
end