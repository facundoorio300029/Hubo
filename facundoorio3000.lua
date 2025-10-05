-- Hub: facundoorio3000 (by Facu 😎)
-- LocalScript (StarterGui)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local savedCFrame = nil
local noclipEnabled = false
local savedCanCollide = {}

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
teamText.TextColor3 = Color3.fromRGB(255, 0, 120)
teamText.TextStrokeTransparency = 0.2

-- Animación “boom”
teamText.TextTransparency = 1
teamText.Position = UDim2.new(0.5, 0, 0.5, 0)
teamText.AnchorPoint = Vector2.new(0.5, 0.5)
teamText.Size = UDim2.new(0, 0, 0, 0)

task.wait(0.3)
local tween1 = TweenService:Create(teamText, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {TextTransparency = 0, Size = UDim2.new(1, 0, 1, 0)})
tween1:Play()
tween1.Completed:Wait()

task.wait(1.5)
local tween2 = TweenService:Create(teamText, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
    {TextTransparency = 1})
tween2:Play()
tween2.Completed:Wait()

screenGuiIntro:Destroy()

--==================== FUNCIONES PRINCIPALES ====================
local function getCharacterAndRoot()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    return char, hrp
end

local function enableNoclip()
    if noclipEnabled then return end
    local char = player.Character
    if not char then return end
    savedCanCollide = {}
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            savedCanCollide[part] = part.CanCollide
            part.CanCollide = false
        end
    end
    noclipEnabled = true
end

local function disableNoclip()
    if not noclipEnabled then return end
    local char = player.Character
    if not char then return end
    for part, original in pairs(savedCanCollide) do
        if part and part.Parent then
            part.CanCollide = original
        end
    end
    savedCanCollide = {}
    noclipEnabled = false
end

local function toggleNoclip()
    if noclipEnabled then
        disableNoclip()
    else
        enableNoclip()
    end
end

player.CharacterAdded:Connect(function()
    task.wait(0.1)
    if noclipEnabled then
        enableNoclip()
    else
        disableNoclip()
    end
end)

local function savePosition()
    local _, hrp = getCharacterAndRoot()
    if hrp then
        savedCFrame = hrp.CFrame
        print("[facundoorio3000] Posición guardada:", savedCFrame)
    end
end

local function teleportToSaved()
    local _, hrp = getCharacterAndRoot()
    if not hrp then return end
    if not savedCFrame then
        warn("[facundoorio3000] No hay posición guardada. Usa Tp1 para guardar.")
        return
    end
    hrp.CFrame = savedCFrame + Vector3.new(0, 3, 0)
    print("[facundoorio3000] Teletransportado a la posición guardada.")
end

--==================== GUI PRINCIPAL ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "facundoorio3000_GUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0, 200, 0, 130)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -65)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 28)
title.BackgroundTransparency = 1
title.Text = "⚡ FACUNDOORIO3000 ⚡"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 0, 200)
title.TextScaled = true
title.Parent = mainFrame

local function makeButton(y, text, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 30)
    b.Position = UDim2.new(0, 10, 0, y)
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextScaled = true
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.BackgroundColor3 = color
    b.BorderSizePixel = 0
    b.Parent = mainFrame
    return b
end

local btnTp1 = makeButton(35, "Tp1 — Guardar posición", Color3.fromRGB(255, 0, 90))
local btnTp2 = makeButton(70, "Tp2 — Ir a guardada", Color3.fromRGB(0, 90, 255))
local btnTras = makeButton(105, "Tras — Noclip", Color3.fromRGB(150, 0, 255))

btnTp1.MouseButton1Click:Connect(function()
    savePosition()
    btnTp1.Text = "✔ Guardada"
    task.wait(1.2)
    btnTp1.Text = "Tp1 — Guardar posición"
end)

btnTp2.MouseButton1Click:Connect(function()
    teleportToSaved()
    btnTp2.Text = "✔ Teleportado"
    task.wait(1.2)
    btnTp2.Text = "Tp2 — Ir a guardada"
end)

btnTras.MouseButton1Click:Connect(function()
    toggleNoclip()
    if noclipEnabled then
        btnTras.Text = "Tras — ON"
    else
        btnTras.Text = "Tras — OFF"
    end
    task.wait(1.2)
    btnTras.Text = "Tras — Noclip"
end)
