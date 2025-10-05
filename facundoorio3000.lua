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

local function savePosition
