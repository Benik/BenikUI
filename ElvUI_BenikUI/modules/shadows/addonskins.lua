local BUI, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')
local mod = BUI:GetModule('Shadows')

-- AddonSkins tabs
function mod:TabShadowsAS(tab)
	if not tab then return end

	if tab.Backdrop then
		tab.Backdrop:CreateSoftShadow()
	end
end

function mod:DBMShadows()
	if not BUI.AS then return end
	local AS = unpack(AddOnSkins) -- this is needed cause it's ADDON_LOADED

	local function SkinBars(self)
		for bar in self:GetBarIterator() do
			if not bar.injected then
				hooksecurefunc(bar, "ApplyStyle", function()
					local frame = bar.frame
					local tbar = _G[frame:GetName()..'Bar']
					local icon1 = _G[frame:GetName()..'BarIcon1']
					local icon2 = _G[frame:GetName()..'BarIcon2']
					local name = _G[frame:GetName()..'BarName']
					local timer = _G[frame:GetName()..'BarTimer']

					if not icon1.overlay then
						icon1.overlay = CreateFrame('Frame', '$parentIcon1Overlay', tbar)
						AS:SetTemplate(icon1.overlay)
						icon1.overlay:SetFrameLevel(0)
						icon1.overlay:Point('BOTTOMRIGHT', frame, 'BOTTOMLEFT', -(AS.PixelMode and 2 or 3), 0)
						icon1.overlay:CreateSoftShadow()
					end

					if not icon2.overlay then
						icon2.overlay = CreateFrame('Frame', '$parentIcon2Overlay', tbar)
						AS:SetTemplate(icon2.overlay)
						icon2.overlay:SetFrameLevel(0)
						icon2.overlay:Point('BOTTOMLEFT', frame, 'BOTTOMRIGHT', (AS.PixelMode and 2 or 3), 0)
						icon2.overlay:CreateSoftShadow()
					end

					AS:SkinTexture(icon1)
					icon1:ClearAllPoints()
					icon1:SetInside(icon1.overlay)

					AS:SkinTexture(icon2)
					icon2:ClearAllPoints()
					icon2:SetInside(icon2.overlay)

					icon1.overlay:Size(bar.owner.options.Height, bar.owner.options.Height)
					icon2.overlay:Size(bar.owner.options.Height, bar.owner.options.Height)
					tbar:SetInside(frame)

					AS:SetTemplate(frame, 'Transparent')
					frame:CreateSoftShadow()

					name:ClearAllPoints()
					name:Width(165)
					name:Height(8)
					name:SetJustifyH('LEFT')
					name:SetShadowColor(0, 0, 0, 0)

					timer:ClearAllPoints()
					timer:SetJustifyH('RIGHT')
					timer:SetShadowColor(0, 0, 0, 0)

					if AS:CheckOption('DBMSkinHalf') then
						frame:Height(bar.owner.options.Height / 3)
						name:Point('BOTTOMLEFT', frame, 'TOPLEFT', 0, 3)
						timer:Point('BOTTOMRIGHT', frame, 'TOPRIGHT', -1, 1)
					else
						frame:Height(bar.owner.options.Height)
						name:Point('LEFT', frame, 'LEFT', 4, 0)
						timer:Point('RIGHT', frame, 'RIGHT', -4, 0)
					end

					timer:SetFont(AS.LSM:Fetch('font', AS:CheckOption('DBMFont')), AS:CheckOption('DBMFontSize'), AS:CheckOption('DBMFontFlag'))
					name:SetFont(AS.LSM:Fetch('font', AS:CheckOption('DBMFont')), AS:CheckOption('DBMFontSize'), AS:CheckOption('DBMFontFlag'))

					if bar.owner.options.IconLeft then icon1.overlay:Show() else icon1.overlay:Hide() end
					if bar.owner.options.IconRight then icon2.overlay:Show() else icon2.overlay:Hide() end

					bar.injected = true
				end)
				bar:ApplyStyle()
			end
		end
	end

	if DBM then -- We need this check, if DBM isnt loaded = error!
		hooksecurefunc(DBT, 'CreateBar', SkinBars)
	end
end

function mod:AddonSkins()
	if not BUI.AS then return end
	local AS = unpack(AddOnSkins)

	hooksecurefunc(AS, "SkinTab", mod.TabShadowsAS)

	if BUI.ShadowMode and E.db.benikuiSkins.addonSkins.dbm then
		mod:DBMShadows()
	end
end