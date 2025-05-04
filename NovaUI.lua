-- NovaUI - Sci-fi styled UI Library (Early Version)
-- Created for universal compatibility (PC + Mobile)
-- Features: Theme Picker, Keybind, Draggable (PC), Minimize, Toggles, Buttons, Sliders

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local NovaUI = {}
local dragging, dragInput, dragStart, startPos = false
local selectedTheme = { Mode = "Dark", Color = Color3.fromRGB(0, 170, 255) }

-- Utility
local function isTyping()
    return UserInputService:GetFocusedTextBox() ~= nil
end

local function createMainUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NovaUI"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- Main Frame
    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 400, 0, 300)
    frame.Position = UDim2.new(0.5, -200, 0.5, -150)
    frame.BackgroundColor3 = selectedTheme.Color
    frame.BorderSizePixel = 0
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "NovaUI - Sci/Fi Library"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Parent = frame

    -- Draggable (PC Only)
    if UserInputService.MouseEnabled then
        title.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    -- Minimize button
    local minimize = Instance.new("TextButton")
    minimize.Text = "-"
    minimize.Size = UDim2.new(0, 30, 0, 30)
    minimize.Position = UDim2.new(1, -30, 0, 0)
    minimize.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    minimize.TextColor3 = Color3.new(1, 1, 1)
    minimize.Font = Enum.Font.GothamBold
    minimize.TextSize = 18
    minimize.Parent = frame

    local contentVisible = true

    minimize.MouseButton1Click:Connect(function()
        contentVisible = not contentVisible
        for _, v in pairs(frame:GetChildren()) do
            if v:IsA("GuiObject") and v ~= title and v ~= minimize then
                v.Visible = contentVisible
            end
        end
    end)

    -- Sample Button
    local button = Instance.new("TextButton")
    button.Text = "Click Me"
    button.Size = UDim2.new(0, 200, 0, 40)
    button.Position = UDim2.new(0.5, -100, 0, 60)
    button.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 16
    button.Parent = frame

    button.MouseButton1Click:Connect(function()
        print("[NovaUI] Button clicked!")
    end)

    -- Sample Toggle
    local toggle = Instance.new("TextButton")
    toggle.Text = "Toggle [OFF]"
    toggle.Size = UDim2.new(0, 200, 0, 40)
    toggle.Position = UDim2.new(0.5, -100, 0, 110)
    toggle.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.Font = Enum.Font.Gotham
    toggle.TextSize = 16
    toggle.Parent = frame

    local toggleState = false
    toggle.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        toggle.Text = toggleState and "Toggle [ON]" or "Toggle [OFF]"
        print("[NovaUI] Toggle state:", toggleState)
    end)

    -- Keybind to toggle UI (PC Only)
    local keybind = Enum.KeyCode.RightShift
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp or isTyping() then return end
        if input.KeyCode == keybind then
            frame.Visible = not frame.Visible
        end
    end)
end

-- Theme Selection Screen
local function themeSetup()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NovaUI_Setup"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 200)
    frame.Position = UDim2.new(0.5, -150, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Text = "Choose Your Theme"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.BackgroundTransparency = 1
    title.Parent = frame

    local color = Instance.new("TextButton")
    color.Text = "Pick Blue Theme"
    color.Size = UDim2.new(0, 200, 0, 40)
    color.Position = UDim2.new(0.5, -100, 0, 60)
    color.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    color.TextColor3 = Color3.new(1, 1, 1)
    color.Font = Enum.Font.Gotham
    color.TextSize = 16
    color.Parent = frame

    local mode = Instance.new("TextButton")
    mode.Text = "Dark Mode"
    mode.Size = UDim2.new(0, 200, 0, 40)
    mode.Position = UDim2.new(0.5, -100, 0, 110)
    mode.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    mode.TextColor3 = Color3.new(1, 1, 1)
    mode.Font = Enum.Font.Gotham
    mode.TextSize = 16
    mode.Parent = frame

    color.MouseButton1Click:Connect(function()
        selectedTheme.Color = Color3.fromRGB(0, 170, 255)
        screenGui:Destroy()
        createMainUI()
    end)
end

-- Run the UI
pcall(themeSetup)
return NovaUI
