local E, L, V, P, G = unpack(ElvUI);
local EP = LibStub('LibElvUIPlugin-1.0')
local addon, Engine = ...

local BUI = LibStub("AceAddon-3.0"):NewAddon(addon, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")
BUI.callbacks = BUI.callbacks or LibStub("CallbackHandler-1.0"):New(BUI)

Engine[1] = BUI
Engine[2] = E
Engine[3] = L
Engine[4] = V
Engine[5] = P
Engine[6] = G
_G[addon] = Engine;

BUI.Config = {}

BUI["RegisteredModules"] = {}
local modules = {}
function BUI:RegisterModule(name)
	if self.initialized then
		local mod = self:GetModule(name)
		if (mod and mod.Initialize) then
			mod:Initialize()
		end
	else
		self["RegisteredModules"][#self["RegisteredModules"] + 1] = name
	end
end

function BUI:InitializeModules()
	for _, moduleName in pairs(BUI["RegisteredModules"]) do
		local mod = self:GetModule(moduleName)
		if mod.Initialize then
			mod:Initialize()
		else
			BUI:Print("Module <"..moduleName.."> is not loaded.")
		end
	end

	BUI.Modules = modules
end

function BUI:AddOptions()
	for _, func in pairs(BUI.Config) do
		func()
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	BUI:Init()
end)

function BUI:Init()
	self.initialized = true
	self:Initialize()
	self:InitializeModules()
	EP:RegisterPlugin(addon, self.AddOptions)
end