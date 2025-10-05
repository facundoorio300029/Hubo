

repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
repeat task.wait() until player:FindFirstChild("PlayerGui")

local savedCFrame = nil
local noclipEnabled = false
local savedCanCollide = {}

--==================== ANIMACIÓN TEAMFACU (BOOM desde la derecha) ====================
local screenGuiIntro = Instance.new("ScreenGui")
screenGuiIntro.IgnoreGuiInset = true
screenGuiIntro.ResetOnSpawn = false
screenGuiIntro.Name = "TEAMFACU_Intro"
screenGuiIntro.Parent = player.PlayerGui

local teamText = Instance.new("TextLabel")
teamText.Parent = screenGuiIntro
teamText.Size = UDim2.new(0.8, 0, 0.3, 0)
teamText.Position = UDim2.new(1.2, 0, 0.4, 0)
teamText.BackgroundTransparency = 1
teamText.Text = "💥 TEAMFACU 💥"
teamText.Font = Enum.Font.GothamBlack
teamText.TextScaled = true
teamText.TextColor3 = Color3.fromRGB(255, 0, 120)
teamText.TextStrokeTransparency = 0.2
teamText.AnchorPoint = Vector2.new(0.5, 0.5)

-- Animación de entrada tipo “BOOM” desde el costado
local tweenIn = TweenService:Create(teamText, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Position = UDim2.new(0.5, 0, 0.4, 0)})
tweenIn:Play()
tweenIn.Completed:Wait()

-- Pequeño efecto de boom (escala rápida)
local tweenBoom = TweenService:Create(teamText, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Size = UDim2.new(0.9, 0, 0.35, 0)})
tweenBoom:Play()
tweenBoom.Completed:Wait()

task.wait(2.5)

-- Desaparece suavemente
local tweenOut = TweenService:Create(teamText, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
    {TextTransparency = 1})
tweenOut:Play()
tweenOut.Completed:Wait()
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
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0, 200, 0, 130)
mainFrame.Position = UDim2.new(1, -210, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 28)
title.BackgroundTransparency = 1
title.Text = "⚡ FACUNDOORIO3000
