-- ⚡ facundoorio3000 Hub — versión movible y colorida 😎
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local savedCFrame = nil
local noclipEnabled = false

-- 🧍 Función para obtener el personaje y la raíz
local function getCharacterAndRoot()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	return char, hrp
end

-- 💾 Guardar y teletransportar posición
local function savePosition()
	local _, hrp = getCharacterAndRoot()
	if hrp then
		savedCFrame = hrp.CFrame
		print("[facundoorio3000] Posición guardada ✔")
	end
end

local function teleportToSaved()
	local _, hrp = getCharacterAndRoot()
	if savedCFrame then
		hrp.CFrame = savedCFrame + Vector3.new(0, 3, 0)
		print("[facundoorio3000] Teletransportado ✔")
	else
		warn("[facundoorio3000] No hay posición guardada.")
	end
end

-- 🚪 Noclip toggle
RunService.Stepped:Connect(function()
	if noclipEnabled and player.Character then
		for _, v in pairs(player.Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

local function toggleNoclip()
	noclipEnabled = not noclipEnabled
	print("[facundoorio3000] Noclip:", noclipEnabled and "Activado" or "Desactivado")
end

-- 🧱 Crear GUI
local gui = Instance.new("ScreenGui")
gui.Name = "facundoorio3000_GUI"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local shadow = Instance.new("UIStroke", frame)
shadow.Thickness = 2
shadow.Color = Color3.fromRGB(0, 200, 255)

local title = Instance.new("TextLabel", frame)
title.Text = "⚡ facundoorio3000 ⚡"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- 🖱️ Hacer la ventana movible
frame.Active = true
frame.Draggable = true

-- 🌈 Función para crear botones animados
local function makeButton(yPos, text, callback)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(1, -20, 0, 30)
	b.Position = UDim2.new(0, 10, 0, yPos)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.Font = Enum.Font.Gotham
	b.TextSize = 16

	local corner = Instance.new("UICorner", b)
	corner.CornerRadius = UDim.new(0, 8)

	b.MouseEnter:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 200, 255)}):Play()
	end)

	b.MouseLeave:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 170, 255)}):Play()
	end)

	b.MouseButton1Click:Connect(function()
		callback()
		TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		task.wait(0.1)
		TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 255)}):Play()
	end)
end

-- 🔘 Botones
makeButton(40, "💾 Guardar posición", savePosition)
makeButton(75, "🌀 Teletransportar", teleportToSaved)
makeButton(110, "🚪 Noclip (ON/OFF)", toggleNoclip)

print("[facundoorio3000] Hub cargado y listo 🚀")
