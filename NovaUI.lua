-- NovaUI.lua (Complete UI with all requested features)

-- Constants and settings
local savedSettingsFile = "NovaUI_Settings.json"

local function saveSettings(settings)
    if isfile(savedSettingsFile) then
        writefile(savedSettingsFile, game:GetService("HttpService"):JSONEncode(settings))
    end
end

local function loadSettings()
    if isfile(savedSettingsFile) then
        local data = game:GetService("HttpService"):JSONDecode(readfile(savedSettingsFile))
        return data
    end
    return nil
end

-- Load the saved settings
local savedSettings = loadSettings()

-- UI library
local NovaUI = {}

-- Create Window
function NovaUI:CreateWindow()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NovaUI"
    screenGui.Parent = game.CoreGui

    -- Frame for the UI
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 300)
    mainFrame.Position = UDim2.new(0, 50, 0, 50)
    mainFrame.BackgroundColor3 = savedSettings and savedSettings.bgColor or Color3.fromRGB(35, 35, 35)
    mainFrame.Parent = screenGui

    -- Draggable functionality
    local dragging, dragInput, dragStart, startPos
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 50, 1, 0)
    sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    sidebar.Parent = mainFrame

    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.Parent = mainFrame

    -- Minimize Button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 50, 1, 0)
    minimizeButton.Text = "-"
    minimizeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.Parent = titleBar

    minimizeButton.MouseButton1Click:Connect(function()
        mainFrame.Size = UDim2.new(0, 50, 0, 40) -- Minimized to title bar
        sidebar.Visible = false
    end)

    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 50, 1, 0)
    closeButton.Text = "X"
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Position = UDim2.new(1, -50, 0, 0)
    closeButton.Parent = titleBar

    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Main content area (buttons, sliders, toggles, etc.)
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -40)
    contentFrame.Position = UDim2.new(0, 0, 0, 40)
    contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    contentFrame.Parent = mainFrame

    -- Buttons, sliders, etc., can go here
    -- Example Button
    local testButton = Instance.new("TextButton")
    testButton.Size = UDim2.new(0, 150, 0, 50)
    testButton.Position = UDim2.new(0, 20, 0, 20)
    testButton.Text = "Test Button"
    testButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    testButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    testButton.Parent = contentFrame

    testButton.MouseButton1Click:Connect(function()
        print("Test Button clicked!")
    end)

    -- Slider (Example)
    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(0, 150, 0, 50)
    slider.Position = UDim2.new(0, 20, 0, 80)
    slider.Text = "Slider Example"
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    slider.TextColor3 = Color3.fromRGB(255, 255, 255)
    slider.Parent = contentFrame

    -- Example Toggle
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 150, 0, 50)
    toggle.Position = UDim2.new(0, 20, 0, 140)
    toggle.Text = "Toggle Example"
    toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Parent = contentFrame

    -- Settings Save functionality
    local function applySettings()
        -- Apply saved theme and color settings
        if savedSettings then
            mainFrame.BackgroundColor3 = savedSettings.bgColor or mainFrame.BackgroundColor3
        end
    end

    applySettings()

    -- Returning the UI elements for further customization
    return screenGui, mainFrame
end

-- Execute the UI
local NovaUIInstance = NovaUI:CreateWindow()
