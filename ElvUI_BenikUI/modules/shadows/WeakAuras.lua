local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Shadows')

--Credits: Merathilis

local function Skin_WeakAuras(f, fType, data)
	if fType == "icon" then
		if not f.buishadow then
			f.icon.SetTexCoordOld_Changed = f.icon.SetTexCoord
			f.icon.SetTexCoord = function(self, ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
				local cLeft, cRight, cTop, cDown
				if URx and URy and LRx and LRy then
					cLeft, cRight, cTop, cDown = ULx, LRx, ULy, LRy
				else
					cLeft, cRight, cTop, cDown = ULx, ULy, LLx, LLy
				end

				local left, right, top, down = unpack(E.TexCoords)
				if cLeft == 0 or cRight == 0 or cTop == 0 or cDown == 0 then
					local width, height = cRight - cLeft, cDown - cTop
					if width == height then
						self:SetTexCoordOld_Changed(left, right, top, down)
					elseif width > height then
						self:SetTexCoordOld_Changed(left, right, top + cTop * (right - left), top + cDown * (right - left))
					else
						self:SetTexCoordOld_Changed(left + cLeft * (down - top), left + cRight * (down - top), top, down)
					end
				else
					self:SetTexCoordOld_Changed(cLeft, cRight, cTop, cDown)
				end
			end
			f.icon:SetTexCoord(f.icon:GetTexCoord())
			f:CreateBackdrop()
			f.backdrop:CreateSoftShadow()
			f.backdrop.Center:StripTextures()
			f.backdrop:SetFrameLevel(0)
			f.backdrop.icon = f.icon
			f.backdrop:HookScript("OnUpdate", function(self)
				self:SetAlpha(self.icon:GetAlpha())
				if self.shadow then
					self.shadow:SetAlpha(self.icon:GetAlpha())
				end
			end)

			f.buishadow = true
		end
	elseif fType == "aurabar" then
		if not f.buishadow and data ~= nil and data.height>2 then
			f:CreateBackdrop()
			f.backdrop.Center:StripTextures()
			f.backdrop:SetFrameLevel(0)
			f.backdrop:CreateSoftShadow()
			f.icon:SetTexCoord(unpack(E.TexCoords))
			f.icon.SetTexCoord = E.noop
			f.iconFrame:SetAllPoints(f.icon)
			f.iconFrame:CreateBackdrop()
			hooksecurefunc(f.icon, "Hide", function()
				f.iconFrame.backdrop:SetShown(false)
			end)

			hooksecurefunc(f.icon, "Show", function()
				f.iconFrame.backdrop:SetShown(true)
			end)

			f.buishadow = true
		end
	end
end

local function LoadSkin()
	local WeakAuras = _G.WeakAuras

	local function OnPrototypeCreate(region)
		Skin_WeakAuras(region, region.regionType)
	end

	local function OnPrototypeModifyFinish(_, region, data)
		Skin_WeakAuras(region, region.regionType, data)
	end

	mod:SecureHook(WeakAuras.regionPrototype, "create", OnPrototypeCreate)
	mod:SecureHook(WeakAuras.regionPrototype, "modifyFinish", OnPrototypeModifyFinish)
end

function mod:WeakAuras()
	if BUI.MER or not BUI.WA then return end

	if E.db.benikui.skins.variousSkins.wa then
		-- LoadSkin()
	end
end
