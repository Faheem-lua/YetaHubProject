-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SaveReturnGUI"
screenGui.Parent = PlayerGui

-- Save Button
local saveButton = Instance.new("TextButton")
saveButton.Size = UDim2.new(0, 120, 0, 40)
saveButton.Position = UDim2.new(0.05, 0, 0.1, 0)
saveButton.Text = "Save Point"
saveButton.BackgroundColor3 = Color3.fromRGB(70, 70, 255)
saveButton.TextColor3 = Color3.new(1, 1, 1)
saveButton.Font = Enum.Font.SourceSansBold
saveButton.TextSize = 18
saveButton.Parent = screenGui

-- Return Button
local returnButton = Instance.new("TextButton")
returnButton.Size = UDim2.new(0, 120, 0, 40)
returnButton.Position = UDim2.new(0.05, 0, 0.2, 0)
returnButton.Text = "Return"
returnButton.BackgroundColor3 = Color3.fromRGB(70, 255, 70)
returnButton.TextColor3 = Color3.new(1, 1, 1)
returnButton.Font = Enum.Font.SourceSansBold
returnButton.TextSize = 18
returnButton.Parent = screenGui

-- Variables
local savedPosition = nil

-- Notification Function
local function notify(message)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Save Point",
        Text = message,
        Duration = 3
    })
end

-- Save Position
saveButton.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    savedPosition = hrp.Position
    notify("Position saved successfully!")
end)

-- Spinning Fling Function
local function flingToSavedPosition()
    if not savedPosition then
        notify("No saved position found.")
        return
    end

    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    -- Create a spinning part at the player's position
    local spinPart = Instance.new("Part")
    spinPart.Size = Vector3.new(5, 1, 5)
    spinPart.Anchored = true
    spinPart.CanCollide = false
    spinPart.Transparency = 1
    spinPart.Position = hrp.Position
    spinPart.Parent = workspace

    -- Rotate the part
    local rotation = 0
    local spinConnection
    spinConnection = RunService.Heartbeat:Connect(function()
        rotation = rotation + math.rad(10)
        spinPart.CFrame = CFrame.new(spinPart.Position) * CFrame.Angles(0, rotation, 0)
    end)

    -- Tween the player's HRP to the saved position
    local tweenInfo = TweenInfo.new(
        2, -- Duration
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )

    local goal = {}
    goal.CFrame = CFrame.new(savedPosition)

    local tween = TweenService:Create(hrp, tweenInfo, goal)
    tween:Play()

    -- Cleanup after tween completes
    tween.Completed:Connect(function()
        spinConnection:Disconnect()
        spinPart:Destroy()
        notify("Returned to saved position!")
    end)
end

-- Return Button Click Event
returnButton.MouseButton1Click:Connect(function()
    flingToSavedPosition()
end)
