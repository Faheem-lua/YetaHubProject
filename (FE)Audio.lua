local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", playerGui)
ScreenGui.Name = "FaheemAudioGUI"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 200)
Main.Position = UDim2.new(0.5, -150, 0.5, -100)
Main.BackgroundColor3 = Color3.fromRGB(25, 15, 40)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -30, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.Text = "FAHEEM AUDIO (Purple Ember)"
Title.TextColor3 = Color3.fromRGB(255, 175, 100)
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 20, 0, 20)
Close.Position = UDim2.new(1, -25, 0, 5)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 80, 80)
Close.BackgroundTransparency = 1
Close.Font = Enum.Font.GothamBold
Close.TextSize = 14
Close.MouseButton1Click:Connect(function()
	Main.Visible = false
end)

local IDBox = Instance.new("TextBox", Main)
IDBox.Size = UDim2.new(1, -20, 0, 30)
IDBox.Position = UDim2.new(0, 10, 0, 40)
IDBox.PlaceholderText = "Enter Roblox Sound ID"
IDBox.Text = ""
IDBox.Font = Enum.Font.Gotham
IDBox.TextSize = 14
IDBox.TextColor3 = Color3.fromRGB(255, 255, 255)
IDBox.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
Instance.new("UICorner", IDBox).CornerRadius = UDim.new(0, 6)

local PlayBtn = Instance.new("TextButton", Main)
PlayBtn.Size = UDim2.new(0.48, -5, 0, 30)
PlayBtn.Position = UDim2.new(0, 10, 0, 80)
PlayBtn.Text = "Play"
PlayBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayBtn.BackgroundColor3 = Color3.fromRGB(130, 80, 255)
PlayBtn.Font = Enum.Font.GothamBold
PlayBtn.TextSize = 14
Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0, 6)

local StopBtn = Instance.new("TextButton", Main)
StopBtn.Size = UDim2.new(0.48, -5, 0, 30)
StopBtn.Position = UDim2.new(0.52, 0, 0, 80)
StopBtn.Text = "Stop"
StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
StopBtn.Font = Enum.Font.GothamBold
StopBtn.TextSize = 14
Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0, 6)

-- Loading bar
local LoadingBar = Instance.new("Frame", Main)
LoadingBar.Size = UDim2.new(0, 0, 0, 8)
LoadingBar.Position = UDim2.new(0, 0, 1, -8)
LoadingBar.BackgroundColor3 = Color3.fromRGB(180, 90, 255)
Instance.new("UICorner", LoadingBar).CornerRadius = UDim.new(1, 0)

local function simulateLoading()
	LoadingBar.Size = UDim2.new(0, 0, 0, 8)
	local tween = TweenService:Create(LoadingBar, TweenInfo.new(1.5), {Size = UDim2.new(1, 0, 0, 8)})
	tween:Play()
	tween.Completed:Wait()
end

-- Equalizer Frame
local EqualizerFrame = Instance.new("Frame", Main)
EqualizerFrame.Size = UDim2.new(1, 0, 0, 40)
EqualizerFrame.Position = UDim2.new(0, 0, 1, -48)
EqualizerFrame.BackgroundTransparency = 1

local bars = {}
local barCount = 5
for i = 1, barCount do
	local bar = Instance.new("Frame", EqualizerFrame)
	bar.Size = UDim2.new(1 / (barCount * 1.5), 0, 0, 10)
	bar.Position = UDim2.new((i - 1) * (1 / barCount), 5, 1, 0)
	bar.BackgroundColor3 = Color3.fromRGB(200, 100, 255)
	bar.AnchorPoint = Vector2.new(0, 1)
	bar.BorderSizePixel = 0
	bar.BackgroundTransparency = 0.1

	Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

	local glow = Instance.new("UIStroke", bar)
	glow.Thickness = 2
	glow.Color = Color3.fromRGB(255, 180, 255)
	glow.Transparency = 0.4
	glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	table.insert(bars, bar)
end

-- Animate Bars
local Sound = Instance.new("Sound", workspace)
Sound.Name = "FaheemSound"
Sound.Volume = 1
Sound.Looped = true

task.spawn(function()
	while true do
		if Sound.IsPlaying then
			for i, bar in ipairs(bars) do
				local height = math.random(10, 30)
				TweenService:Create(bar, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
					Size = UDim2.new(bar.Size.X.Scale, 0, 0, height)
				}):Play()
			end
		else
			for _, bar in ipairs(bars) do
				TweenService:Create(bar, TweenInfo.new(0.3), {Size = UDim2.new(bar.Size.X.Scale, 0, 0, 10)}):Play()
			end
		end
		task.wait(0.4)
	end
end)

-- Controls
PlayBtn.MouseButton1Click:Connect(function()
	local id = IDBox.Text:match("%d+")
	if id then
		simulateLoading()
		Sound.SoundId = "rbxassetid://" .. id
		Sound:Play()
	end
end)

StopBtn.MouseButton1Click:Connect(function()
	Sound:Stop()
end)
