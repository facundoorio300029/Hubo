-- Hub: TEAMFACU Neon Gamer 😎
-- Autor: Facu
-- Totalmente compatible con Delta (celular)
-- Movible, colores neon y animación boom de entrada

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local savedCanCollide = {}
local noclipEnabled = false
local flyEnabled = false
local flySpeed = 60

--==================== ANIMACIÓN TEAMFACU ====================
local screenGuiIntro = Instance.new("ScreenGui")
screenGuiIntro.IgnoreGuiInset = true
screenGuiIntro.ResetOnSpawn = false
screenGuiIntro.Name = "TEAMFACU_Intro"
screenGuiIntro.Parent = player:WaitForChild("PlayerGui")

local teamText = Instance.new("TextLabel")
teamText.Parent = screenGuiIntro
teamText.Size = UDim2.new(1, 0, 1, 0)
teamText.BackgroundTransparency = 1
teamText.Text = "💥 TEAMFACU 💥"
teamText.Font = Enum.Font.GothamBlack
teamText.TextScaled = true
teamText.TextColor3 = Color3.fromRGB(90, 0, 255)
teamText.TextStrokeTransparency = 0.2

teamText.TextTransparency = 1
teamText.Position = UDim2.new(0.5, 0, 0.5, 0)
teamText.AnchorPoint = Vector2.new(0.5, 0.5)
teamText.Size = UDim2.new(0, 0, 0, 0)

task.wait(0.3)
local boom = TweenService:Create(teamText, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	TextTransparency = 0,
	Size = UDim2.new(1, 0, 1, 0)
})
boom:Play()
boom.Completed:Wait()

task.wait(1.5)
local fade = TweenService:Create(teamText, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
	TextTransparency = 1
})
fade:Play()
fade.Completed:Wait()
screenGuiIntro:Destroy()

--==================== FUNCIONES ====================
local function getCharacterAndRoot()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:FindFirstChild("HumanoidRootPart")
	return char, hrp
end

-- Noclip
local function enableNoclip()
	local char = player.Character
	if not char then return end
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			savedCanCollide[part] = part.CanCollide
			part.CanCollide = false
		end
	end
	noclipEnabled = true
end

local function disableNoclip()
	local char = player.Character
	if not char then return end
	for part, original in pairs(savedCanCollide) do
		if part and part.Parent then
			part.CanCollide = original
		end
	end
	noclipEnabled = false
end

local function toggleNoclip()
	if noclipEnabled then
		disableNoclip()
	else
		enableNoclip()
	end
end

-- Fly
local function toggleFly()
	flyEnabled = not flyEnabled
	local _, hrp = getCharacterAndRoot()
	if not hrp then return end
	if flyEnabled then
		local bodyGyro = Instance.new("BodyGyro")
		local bodyVel = Instance.new("BodyVelocity")
		bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		bodyGyro.P = 10000
		bodyGyro.Parent = hrp
		bodyVel.Parent = hrp
		bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)

		RunService.RenderStepped:Connect(function()
			if not flyEnabled then
				bodyGyro:Destroy()
				bodyVel:Destroy()
				return
			end
			bodyGyro.CFrame = workspace.CurrentCamera.CFrame
			local moveDir = Vector3.zero
			if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += workspace.CurrentCamera.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= workspace.CurrentCamera.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir -= workspace.CurrentCamera.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += workspace.CurrentCamera.CFrame.RightVector end
			bodyVel.Velocity = moveDir * flySpeed
		end)
	end
end

--==================== GUI ====================
local gui = Instance.new("ScreenGui")
gui.Name = "TEAMFACU_GUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 240)
frame.Position = UDim2.new(1, -210, 0.5, -120)
frame.BackgroundColor3 = Color3.fromRGB(80, 0, 200)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = frame

-- Drag (para celular)
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.Touch then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "⚡ TEAMFACU ⚡"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Parent = frame

local function makeButton(y, text, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 35)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = color
	btn.Text = text
	btn.Font = Enum.Font.Gotham
	btn.TextScaled = true
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Parent = frame
	local c = Instance.new("UICorner", btn)
	c.CornerRadius = UDim.new(0, 8)
	return btn
end

local btnTras = makeButton(45, "Tras — Noclip", Color3.fromRGB(255, 0, 120))
local speedLabel = makeButton(90, "Speed", Color3.fromRGB(0, 80, 255))
local jumpLabel = makeButton(135, "Jump", Color3.fromRGB(120, 0, 255))
local btnFly = makeButton(180, "Fly — OFF", Color3.fromRGB(255, 50, 200))

-- Campos de texto
local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(0, 80, 0, 25)
speedBox.Position = UDim2.new(0, 110, 0, 95)
speedBox.Text = "16"
speedBox.PlaceholderText = "Velocidad"
speedBox.TextScaled = true
speedBox.BackgroundColor3 = Color3.fromRGB(0, 0, 80)
speedBox.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", speedBox)

local jumpBox = Instance.new("TextBox", frame)
jumpBox.Size = UDim2.new(0, 80, 0, 25)
jumpBox.Position = UDim2.new(0, 110, 0, 140)
jumpBox.Text = "50"
jumpBox.PlaceholderText = "Salto"
jumpBox.TextScaled = true
jumpBox.BackgroundColor3 = Color3.fromRGB(30, 0, 100)
jumpBox.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", jumpBox)

--==================== FUNCIONES DE BOTONES ====================
btnTras.MouseButton1Click:Connect(toggleNoclip)

speedLabel.MouseButton1Click:Connect(function()
	local char = player.Character
	if char and char:FindFirstChildOfClass("Humanoid") then
		char:FindFirstChildOfClass("Humanoid").WalkSpeed = tonumber(speedBox.Text) or 16
	end
end)

jumpLabel.MouseButton1Click:Connect(function()
	local char = player.Character
	if char and char:FindFirstChildOfClass("Humanoid") then
		char:FindFirstChildOfClass("Humanoid").JumpPower = tonumber(jumpBox.Text) or 50
	end
end)

btnFly.MouseButton1Click:Connect(function()
	toggleFly()
	btnFly.Text = flyEnabled and "Fly — ON" or "Fly — OFF"
end)
