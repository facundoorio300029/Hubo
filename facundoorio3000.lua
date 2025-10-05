-- FACUNDOORIO3000 HUB — Versión completa (Neon azul, mediano) — Delta compatible
-- LocalScript para ejecutar con: loadstring(game:HttpGet("https://raw.githubusercontent.com/facundoorio300029/Hubo/main/facundoorio3000.lua"))()

-- Preparaciones (Delta-friendly)
repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
repeat task.wait() until player:FindFirstChild("PlayerGui")

-- Estado
local savedCanCollide = {}
local noclipEnabled = false
local flying = false
local flyConn = nil
local flySpeed = 70
local speedStored = 16
local jumpStored = 50

-- Helpers
local function getCharacterAndHumanoid()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local humanoid = char:WaitForChild("Humanoid")
	return char, hrp, humanoid
end

-- ================= INTRO TEAMFACU =================
local introGui = Instance.new("ScreenGui")
introGui.Name = "FACUIntroGui"
introGui.ResetOnSpawn = false
introGui.IgnoreGuiInset = true
introGui.Parent = player.PlayerGui

local bigText = Instance.new("TextLabel")
bigText.Size = UDim2.new(1,0,1,0)
bigText.Position = UDim2.new(0,0,0,0)
bigText.BackgroundTransparency = 1
bigText.Text = "💥 TEAMFACU 💥"
bigText.Font = Enum.Font.GothamBlack
bigText.TextScaled = true
bigText.TextColor3 = Color3.fromRGB(100,200,255)
bigText.TextStrokeTransparency = 0.25
bigText.TextTransparency = 1
bigText.AnchorPoint = Vector2.new(0.5,0.5)
bigText.Position = UDim2.new(0.5,0,0.5,0)
bigText.Parent = introGui

-- pop-in boom
task.wait(0.15)
TweenService:Create(bigText, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	TextTransparency = 0,
	Size = UDim2.new(1,0,1,0)
}):Play()
task.wait(2.1)
TweenService:Create(bigText, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
	TextTransparency = 1
}):Play()
task.wait(0.75)
introGui:Destroy()

-- ================= MAIN GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "facundoorio3000_GUI"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

-- frame (mediano) — empieza fuera a la izquierda
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 260, 0, 220)
frame.Position = UDim2.new(0, -280, 0.4, -110) -- off-screen left
frame.BackgroundColor3 = Color3.fromRGB(8, 12, 30)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0
frame.Parent = gui
local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0,14)

-- glow stroke
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(40,120,255)
stroke.Transparency = 0.15

-- slide in from left
TweenService:Create(frame, TweenInfo.new(0.9, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Position = UDim2.new(0, 18, 0.4, -110)
}):Play()

-- title bar
local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1,0,0,36)
titleBar.Position = UDim2.new(0,0,0,0)
titleBar.BackgroundTransparency = 1

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -36, 1, 0)
title.Position = UDim2.new(0,8,0,0)
title.BackgroundTransparency = 1
title.Text = "⚡ FACUNDOORIO3000 ⚡"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(170,220,255)

-- minimize button (becomes slim bar when minimized)
local minimizeBtn = Instance.new("TextButton", titleBar)
minimizeBtn.Size = UDim2.new(0,28,0,28)
minimizeBtn.Position = UDim2.new(1,-36,0,4)
minimizeBtn.BackgroundTransparency = 0.15
minimizeBtn.BackgroundColor3 = Color3.fromRGB(30,60,140)
minimizeBtn.Text = "─"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
minimizeBtn.TextScaled = true
minimizeBtn.AutoButtonColor = true
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0,6)

local minimized = false

minimizeBtn.MouseButton1Click:Connect(function()
	if not minimized then
		-- shrink to slim bar
		TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
			Size = UDim2.new(0, 140, 0, 36)
		}):Play()
		minimized = true
	else
		-- restore size
		TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
			Size = UDim2.new(0, 260, 0, 220)
		}):Play()
		minimized = false
	end
end)

-- energy/power bar background
local energyBg = Instance.new("Frame", frame)
energyBg.Size = UDim2.new(0, 220, 0, 8)
energyBg.Position = UDim2.new(0, 18, 0, 46)
energyBg.BackgroundColor3 = Color3.fromRGB(20,20,40)
energyBg.BorderSizePixel = 0
Instance.new("UICorner", energyBg).CornerRadius = UDim.new(0,6)

local energyFill = Instance.new("Frame", energyBg)
energyFill.Size = UDim2.new(0, 0, 1, 0)
energyFill.BackgroundColor3 = Color3.fromRGB(0,160,255)
energyFill.BorderSizePixel = 0
Instance.new("UICorner", energyFill).CornerRadius = UDim.new(0,6)

local function setEnergy(p)
	p = math.clamp(p, 0, 1)
	TweenService:Create(energyFill, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Size = UDim2.new(p,0,1,0)}):Play()
end

-- Buttons + inputs area
local function makeBtn(parent, y, text, color)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(0, 180, 0, 36)
	b.Position = UDim2.new(0, 18, 0, y)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.TextColor3 = Color3.fromRGB(16,16,24)
	b.BackgroundColor3 = color
	b.BorderSizePixel = 0
	local c = Instance.new("UICorner", b); c.CornerRadius = UDim.new(0,8)
	return b
end

local function makeBox(parent, y, placeholder, default)
	local box = Instance.new("TextBox", parent)
	box.Size = UDim2.new(0, 60, 0, 30)
	box.Position = UDim2.new(0, 206, 0, y)
	box.PlaceholderText = placeholder
	box.Text = tostring(default)
	box.Font = Enum.Font.Gotham
	box.TextScaled = true
	box.TextColor3 = Color3.fromRGB(230,230,255)
	box.BackgroundColor3 = Color3.fromRGB(10,12,24)
	box.BorderSizePixel = 0
	Instance.new("UICorner", box).CornerRadius = UDim.new(0,6)
	return box
end

local btnNoclip = makeBtn(frame, 62, "Tras — Noclip", Color3.fromRGB(160,160,255))
local btnSpeed = makeBtn(frame, 110, "Speed — Aplicar", Color3.fromRGB(80,160,255))
local speedBox = makeBox(frame, 108, "16", 16)
local btnJump = makeBtn(frame, 158, "Jump — Aplicar", Color3.fromRGB(160,100,255))
local jumpBox = makeBox(frame, 156, "50", 50)
local btnFly = makeBtn(frame, 206, "Fly — OFF", Color3.fromRGB(100,180,255))

-- place fly button inside if fits (adjust frame height to fit)
-- adjust frame height to include fly button
frame.Size = UDim2.new(0,260,0,260)
frame.Position = UDim2.new(0,18,0.4,-120)

-- small note text
local note = Instance.new("TextLabel", frame)
note.Size = UDim2.new(0,220,0,24)
note.Position = UDim2.new(0,18,0,220)
note.BackgroundTransparency = 1
note.Text = "Móvil: Arrastra el título para mover | Fly: usa joystick/WASD"
note.Font = Enum.Font.Gotham
note.TextSize = 13
note.TextColor3 = Color3.fromRGB(170,200,255)

-- ================= BUTTON BEHAVIORS =================

-- Noclip
btnNoclip.MouseButton1Click:Connect(function()
	local char = player.Character
	if not char then return end
	if not noclipEnabled then
		savedCanCollide = {}
		for _, part in ipairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				savedCanCollide[part] = part.CanCollide
				part.CanCollide = false
			end
		end
		noclipEnabled = true
		setEnergy(0.8)
		btnNoclip.Text = "Tras — ON"
	else
		for part, canCollide in pairs(savedCanCollide) do
			if part and part.Parent then
				part.CanCollide = canCollide
			end
		end
		savedCanCollide = {}
		noclipEnabled = false
		setEnergy(0)
		btnNoclip.Text = "Tras — Noclip"
	end
end)

-- Speed apply
btnSpeed.MouseButton1Click:Connect(function()
	local char, hrp, humanoid = getCharacterAndHumanoid()
	if humanoid then
		local n = tonumber(speedBox.Text)
		if n and n > 0 then
			speedStored = n
			humanoid.WalkSpeed = speedStored
			setEnergy(0.5)
			-- small blink to indicate apply
			local old = btnSpeed.BackgroundColor3
			TweenService:Create(btnSpeed, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
			task.delay(0.12, function() TweenService:Create(btnSpeed, TweenInfo.new(0.2), {BackgroundColor3 = old}):Play() end)
		end
	end
end)

-- Jump apply
btnJump.MouseButton1Click:Connect(function()
	local char, hrp, humanoid = getCharacterAndHumanoid()
	if humanoid then
		local n = tonumber(jumpBox.Text)
		if n and n > 0 then
			jumpStored = n
			humanoid.JumpPower = jumpStored
			setEnergy(0.6)
			local old = btnJump.BackgroundColor3
			TweenService:Create(btnJump, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
			task.delay(0.12, function() TweenService:Create(btnJump, TweenInfo.new(0.2), {BackgroundColor3 = old}):Play() end)
		end
	end
end)

-- Fly (superhéroe) implementation (Delta-friendly, mobile compatible)
local function startFly()
	if flying then return end
	local char, hrp, humanoid = getCharacterAndHumanoid()
	if not hrp or not humanoid then return end
	flying = true
	humanoid.PlatformStand = true
	btnFly.Text = "Fly — ON"
	setEnergy(1)

	local bodyGyro = Instance.new("BodyGyro")
	bodyGyro.P = 20000
	bodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
	bodyGyro.CFrame = workspace.CurrentCamera.CFrame
	bodyGyro.Parent = hrp

	local bodyVel = Instance.new("BodyVelocity")
	bodyVel.MaxForce = Vector3.new(1e5,1e5,1e5)
	bodyVel.Velocity = Vector3.new(0,0,0)
	bodyVel.Parent = hrp

	flyConn = RunService.RenderStepped:Connect(function()
		if not flying then return end
		local cam = workspace.CurrentCamera
		bodyGyro.CFrame = cam.CFrame
		local moveDir = Vector3.zero
		-- mobile: check thumbstick via UserInputService (Delta joystick maps to input/movement); still support WASD
		if UIS.TouchEnabled then
			-- for mobile, use Humanoid.MoveDirection as fallback
			local char = player.Character
			if char then
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum then moveDir = moveDir + (hum.MoveDirection * 1.5) end
			end
		end
		if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
		-- vertical control with space / control
		if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end

		-- apply velocity scaled by flySpeed
		bodyVel.Velocity = moveDir.Unit ~= moveDir.Unit and Vector3.new(0,0,0) or (moveDir * flySpeed)
	end)
end

local function stopFly()
	if not flying then return end
	flying = false
	local char = player.Character
	if char then
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if humanoid then humanoid.PlatformStand = false end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			for _, v in pairs(hrp:GetChildren()) do
				if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then v:Destroy() end
			end
		end
	end
	if flyConn then flyConn:Disconnect(); flyConn = nil end
	btnFly.Text = "Fly — OFF"
	setEnergy(0)
end

btnFly.MouseButton1Click:Connect(function()
	if flying then stopFly() else startFly() end
end)

-- Re-apply speed/jump and noclip on respawn
player.CharacterAdded:Connect(function(char)
	task.wait(0.2)
	local humanoid = char:WaitForChild("Humanoid")
	humanoid.WalkSpeed = speedStored or 16
	humanoid.JumpPower = jumpStored or 50
	if noclipEnabled then
		for _, part in ipairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				savedCanCollide[part] = part.CanCollide
				part.CanCollide = false
			end
		end
	end
end)

-- Dragging for mobile & PC (titleBar drag)
local dragging = false
local dragStart, startPos
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Small safety: ensure humanoid defaults applied if present
task.delay(0.5, function()
	local char = player.Character
	if char and char:FindFirstChildOfClass("Humanoid") then
		local h = char:FindFirstChildOfClass("Humanoid")
		h.WalkSpeed = speedStored
		h.JumpPower = jumpStored
	end
end)

-- End of script
