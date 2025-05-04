-- YetaHub Splash Screen by Faheem (GothamBlack + Music)
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

-- Screen GUI
local splashGui = Instance.new("ScreenGui", CoreGui)
splashGui.Name = "FaheemSplash"
splashGui.ResetOnSpawn = false

-- Blur
local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 24

-- Music (looped)
local music = Instance.new("Sound", splashGui)
music.SoundId = "rbxassetid://9129219802" -- Replace with your preferred sound ID
music.Volume = 0.8
music.Looped = true
music:Play()

-- Splash Text
local splashText = Instance.new("TextLabel", splashGui)
splashText.Size = UDim2.new(1, 0, 1, 0)
splashText.Position = UDim2.new(0, 0, 0, 0)
splashText.Text = "M A D E  B Y  F A H E E M"
splashText.Font = Enum.Font.GothamBlack
splashText.TextScaled = true
splashText.TextColor3 = Color3.fromRGB(255, 0, 0)
splashText.BackgroundTransparency = 1
splashText.TextStrokeTransparency = 0.5
splashText.TextStrokeColor3 = Color3.new(0, 0, 0)

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.new(0, 0, 0)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
stroke.Parent = splashText

-- Fade Out (Text + Music + Blur)
task.delay(3, function()
	TweenService:Create(splashText, TweenInfo.new(2), {
		TextTransparency = 1,
		TextStrokeTransparency = 1
	}):Play()

	TweenService:Create(music, TweenInfo.new(2), { Volume = 0 }):Play()

	TweenService:Create(blur, TweenInfo.new(2), { Size = 0 }):Play()

	task.wait(2)
	music:Stop()
	splashGui:Destroy()
	blur:Destroy()
end)


-- Lockin Hub Script Starts Here --

local Players = game:GetService("Players")
local player = Players.LocalPlayer
player.CameraMode = Enum.CameraMode.Classic
local runService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local camera = workspace.CurrentCamera

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Npc Lock Gui | Dead Rails"
screenGui.Parent = game:GetService("CoreGui")

local button = Instance.new("TextButton")
button.Name = "NPC Lock: ON/OFF"
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0.5, -75, 0.9, -25)
button.BackgroundColor3 = Color3.new(0, 0, 0)
button.TextColor3 = Color3.new(1, 1, 1)
button.Text = "NPC Lock: OFF"
button.Font = Enum.Font.Fantasy
button.TextScaled = true
button.TextSize = 20
button.Parent = screenGui

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 12)
uicorner.Parent = button

local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = button.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        update(input)
    end
end)

local npcLock = false
local lastTarget = nil
local toggleLoop

local function addPlayerHighlight()
    if player.Character then
        local highlight = player.Character:FindFirstChild("PlayerHighlightESP")
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "PlayerHighlightESP"
            highlight.FillColor = Color3.new(1, 1, 1)
            highlight.OutlineColor = Color3.new(1, 1, 1)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = player.Character
        end
    end
end

local function removePlayerHighlight()
    if player.Character and player.Character:FindFirstChild("PlayerHighlightESP") then
        player.Character.PlayerHighlightESP:Destroy()
    end
end

local function getClosestNPC()
    local closestNPC = nil
    local closestDistance = math.huge

    for _, object in ipairs(workspace:GetDescendants()) do
        if object:IsA("Model") then
            local humanoid = object:FindFirstChild("Humanoid") or object:FindFirstChildWhichIsA("Humanoid")
            local hrp = object:FindFirstChild("HumanoidRootPart") or object.PrimaryPart
            if humanoid and hrp and humanoid.Health > 0 and object.Name ~= "Horse" then
                local isPlayer = false
                for _, pl in ipairs(Players:GetPlayers()) do
                    if pl.Character == object then
                        isPlayer = true
                        break
                    end
                end
                if not isPlayer then
                    local distance = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestNPC = object
                    end
                end
            end
        end
    end

    return closestNPC
end

button.MouseButton1Click:Connect(function()
    npcLock = not npcLock
    if npcLock then
        button.Text = "NPC Lock: ON"
        toggleLoop = runService.RenderStepped:Connect(function()
            local npc = getClosestNPC()
            if npc and npc:FindFirstChild("Humanoid") then
                local npcHumanoid = npc:FindFirstChild("Humanoid")
                if npcHumanoid.Health > 0 then
                    camera.CameraSubject = npcHumanoid
                    lastTarget = npc
                    addPlayerHighlight()
                else
                    lastTarget = nil
                    removePlayerHighlight()
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        camera.CameraSubject = player.Character:FindFirstChild("Humanoid")
                    end
                end
            else
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    camera.CameraSubject = player.Character:FindFirstChild("Humanoid")
                end
                lastTarget = nil
                removePlayerHighlight()
            end
        end)
    else
        button.Text = "NPC Lock: OFF"
        if toggleLoop then
            toggleLoop:Disconnect()
            toggleLoop = nil
        end
        removePlayerHighlight()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            camera.CameraSubject = player.Character:FindFirstChild("Humanoid")
        end
    end
end)
