local BUI, E, L, V, P, G = unpack(select(2, ...))
local BU = BUI:GetModule('Units');

function BU:Configure_RestingIndicator(frame)
	if BUI.SLE then return end -- S&L don't like BenikUI

	local rIcon = frame.RestingIndicator
	local db = frame.db
	if db.restIcon then
	rIcon:ClearAllPoints()

		if frame.USE_PORTRAIT and not frame.USE_PORTRAIT_OVERLAY and frame.PORTRAIT_DETACHED then
			if frame.PORTRAIT_STYLING and frame.Portrait.backdrop.style then
				rIcon:SetParent(frame.Portrait.backdrop.style)
				rIcon:SetPoint("CENTER", frame.Portrait.backdrop.style, "TOPLEFT", -3, 6)
			else
				rIcon:SetParent(frame)
				rIcon:SetPoint("CENTER", frame.Health, "TOPLEFT", -3, 6)
			end
		else
			rIcon:SetParent(frame)
			if frame.ORIENTATION == "RIGHT" then
				rIcon:SetPoint("CENTER", frame.Health, "TOPLEFT", -3, 6)
			else
				if frame.USE_PORTRAIT and not frame.USE_PORTRAIT_OVERLAY then
					rIcon:SetPoint("CENTER", frame.Portrait, "TOPLEFT", -3, 6)
				else
					rIcon:SetPoint("CENTER", frame.Health, "TOPLEFT", -3, 6)
				end
			end
		end
	end
end