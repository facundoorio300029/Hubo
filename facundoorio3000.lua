local Players = game:GetService("Players")
local player = Players.LocalPlayer
local savedCFrame = nil
local noclipEnabled = false
local savedCanCollide = {}

local function getCharacterAndRoot()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
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
    for part, original in pairs(savedCanCollide) do
        if part and part.Parent then
            part.CanCollide = original
        end
    end
    savedCanCollide = {}
    noclipEnabled = false
end

local function toggleNoclip()
    if noclipEnabled then disableNoclip() else enableNoclip() end
end

local function savePosition()
    local _, hrp = getCharacterAndRoot()
    if hrp then savedCFrame = hrp.CFrame end
end

local function teleportToSaved()
    local _, hrp = getCharacterAndRoot()
    if hrp and savedCFrame then
        hrp.CFrame = savedCFrame + Vector3.new(0, 3, 0)
    end
end

local function createGui()
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "facundoorio3000"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 200, 0, 120)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

    local function makeButton(name, y, text, callback)
        local btn = Instance.new("TextButton", frame)
        btn.Name = name
        btn.Text = text
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.Position = UDim2.new(0, 5, 0, y)
        btn.MouseButton1Click:Connect(callback)
    end

    makeButton("Tp1", 10, "Tp1: Guardar", savePosition)
    makeButton("Tp2", 45, "Tp2: Ir", teleportToSaved)
    makeButton("Tras", 80, "Tras: Noclip", toggleNoclip)
end

createGui()
