-- 🔥 FACUNDOORIO3000 AUTO WEAPON GIVER 🔥
-- Compatible con Delta (móvil)
-- Da automáticamente TODAS las herramientas del juego al jugador local

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

local function giveTool(tool)
	if not tool:IsA("Tool") then return end
	local clone = tool:Clone()
	clone.Parent = backpack
end

-- Buscar en todos los lugares comunes donde los juegos guardan armas
local sources = {ServerStorage, ReplicatedStorage, Workspace}

for _, source in ipairs(sources) do
	for _, item in pairs(source:GetDescendants()) do
		if item:IsA("Tool") then
			pcall(function()
				giveTool(item)
			end)
		end
	end
end

-- Confirmación visual
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local msg = Instance.new("TextLabel")
msg.Size = UDim2.new(1, 0, 0, 100)
msg.Position = UDim2.new(0, 0, 0.4, 0)
msg.BackgroundTransparency = 1
msg.Text = "⚡ TODAS LAS ARMAS ENTREGADAS ⚡"
msg.Font = Enum.Font.GothamBlack
msg.TextScaled = true
msg.TextColor3 = Color3.fromRGB(255, 0, 120)
msg.Parent = gui

task.wait(3)
gui:Destroy()
