local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

function UFB:Configure_Stagger(frame)
	local stagger = frame.Stagger
	local db = frame.db

	frame.STAGGER_WIDTH = stagger and frame.STAGGER_SHOWN and (db.stagger.width + (frame.BORDER*2)) or 0;

	if db.stagger.enable then
		stagger:ClearAllPoints()
		if not frame.USE_MINI_POWERBAR and not frame.USE_INSET_POWERBAR and not frame.POWERBAR_DETACHED and not frame.USE_POWERBAR_OFFSET then
			if frame.ORIENTATION == "RIGHT" then
				--Position on left side of health because portrait is on right side
				if frame.USE_EMPTY_BAR then
					stagger:Point('BOTTOMRIGHT', frame.EmptyBar, 'BOTTOMLEFT', -frame.BORDER*3 + (frame.BORDER - frame.SPACING*3), frame.BORDER)
				else
					stagger:Point('BOTTOMRIGHT', frame.Power, 'BOTTOMLEFT', -frame.BORDER*3 + (frame.BORDER - frame.SPACING*3), 0)
				end
				stagger:Point('TOPLEFT', frame.Health, 'TOPLEFT', -frame.STAGGER_WIDTH, 0, 0)
			else
				--Position on right side
				if frame.USE_EMPTY_BAR then
					stagger:Point('BOTTOMLEFT', frame.EmptyBar, 'BOTTOMRIGHT', frame.BORDER*3 + (-frame.BORDER + frame.SPACING*3), frame.BORDER)
				else
					stagger:Point('BOTTOMLEFT', frame.Power, 'BOTTOMRIGHT', frame.BORDER*3 + (-frame.BORDER + frame.SPACING*3), 0)
				end
				stagger:Point('TOPRIGHT', frame.Health, 'TOPRIGHT', frame.STAGGER_WIDTH, 0)
			end
		else
			if frame.ORIENTATION == "RIGHT" then
				--Position on left side of health because portrait is on right side
				if frame.USE_EMPTY_BAR then
					stagger:Point('BOTTOMRIGHT', frame.EmptyBar, 'BOTTOMLEFT', -frame.BORDER*3 + (frame.BORDER - frame.SPACING*3), frame.BORDER)
				else
					stagger:Point('BOTTOMRIGHT', frame.Health, 'BOTTOMLEFT', -frame.BORDER*3 + (frame.BORDER - frame.SPACING*3), 0)
				end
				stagger:Point('TOPLEFT', frame.Health, 'TOPLEFT', -frame.STAGGER_WIDTH, 0)
			else
				--Position on right side
				if frame.USE_EMPTY_BAR then
					stagger:Point('BOTTOMLEFT', frame.EmptyBar, 'BOTTOMRIGHT', frame.BORDER*3 + (-frame.BORDER + frame.SPACING*3), frame.BORDER)
				else
					stagger:Point('BOTTOMLEFT', frame.Health, 'BOTTOMRIGHT', frame.BORDER*3 + (-frame.BORDER + frame.SPACING*3), 0)
				end
				stagger:Point('TOPRIGHT', frame.Health, 'TOPRIGHT', frame.STAGGER_WIDTH, 0)
			end
		end
	end
end