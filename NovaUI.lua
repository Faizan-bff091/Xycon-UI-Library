-- NovaUI: Main Library
local NovaUI = {}
NovaUI.__index = NovaUI

-- Settings storage key
local settingsKey = "NovaUISettings"

-- Check environment
local isPC = not game:GetService("UserInputService").TouchEnabled
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

-- Theme defaults
local themes = {
    ["Neon Blue"] = Color3.fromRGB(0, 170, 255),
    ["Plasma Red"] = Color3.fromRGB(255, 70, 70),
    ["Alien Green"] = Color3.fromRGB(0, 255, 90)
}
local defaultTheme = "Neon Blue"
local defaultMode = "Dark"

local function SaveSettings(settings)
    if settings.shouldSave then
        writefile(settingsKey..".json", game:GetService("HttpService"):JSONEncode(settings))
    end
end

local function LoadSettings()
    if isfile(settingsKey..".json") then
        return game:GetService("HttpService"):JSONDecode(readfile(settingsKey..".json"))
    end
    return nil
end

-- Simple UI constructor
function NovaUI:CreateBase()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NovaUI"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = game.CoreGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 500, 0, 350)
    mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui

    local uiCorner = Instance.new("UICorner", mainFrame)
    uiCorner.CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel")
    title.Text = "NovaUI"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Parent = mainFrame

    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(1, -20, 1, -60)
    container.Position = UDim2.new(0, 10, 0, 50)
    container.BackgroundTransparency = 1
    container.Parent = mainFrame

    local uiList = Instance.new("UIListLayout")
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Padding = UDim.new(0, 10)
    uiList.Parent = container

    -- Dragging
    if isPC then
        local dragging, offset
        title.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                offset = Vector2.new(input.Position.X, input.Position.Y) - mainFrame.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                mainFrame.Position = UDim2.new(0, input.Position.X - offset.X, 0, input.Position.Y - offset.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
    end

    return {
        screenGui = screenGui,
        mainFrame = mainFrame,
        container = container,
        theme = themes[defaultTheme],
        darkMode = defaultMode == "Dark",
        settings = {}
    }
end

-- UI Component: Button
function NovaUI:AddButton(container, text, callback)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = self.theme
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 16
    button.AutoButtonColor = false
    button.Parent = container

    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(0, 8)

    button.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
end

-- Add more components: Toggle, Slider, TextBox, Note, etc.

-- Init logic for theme selection on first run
function NovaUI:Init()
    local saved = LoadSettings()
    if saved then
        self.theme = themes[saved.colorTheme] or self.theme
        self.darkMode = saved.mode == "Dark"
        self.settings = saved
        return self:CreateBase()
    end

    -- Theme selector screen
    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Name = "NovaUISetup"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 300, 0, 200)
    frame.Position = UDim2.new(0.5, -150, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    local dropdown = Instance.new("TextButton", frame)
    dropdown.Text = "Choose Theme"
    dropdown.Size = UDim2.new(1, -20, 0, 40)
    dropdown.Position = UDim2.new(0, 10, 0, 20)
    dropdown.BackgroundColor3 = themes[defaultTheme]
    dropdown.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

    local themeCycle = { "Neon Blue", "Plasma Red", "Alien Green" }
    local index = 1
    dropdown.MouseButton1Click:Connect(function()
        index = index % #themeCycle + 1
        dropdown.Text = themeCycle[index]
        dropdown.BackgroundColor3 = themes[themeCycle[index]]
    end)

    local modeToggle = Instance.new("TextButton", frame)
    modeToggle.Text = "Dark Mode"
    modeToggle.Size = UDim2.new(1, -20, 0, 40)
    modeToggle.Position = UDim2.new(0, 10, 0, 70)
    modeToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    modeToggle.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", modeToggle).CornerRadius = UDim.new(0, 6)

    local mode = "Dark"
    modeToggle.MouseButton1Click:Connect(function()
        mode = (mode == "Dark") and "Light" or "Dark"
        modeToggle.Text = mode .. " Mode"
    end)

    local saveToggle = Instance.new("TextButton", frame)
    saveToggle.Text = "Don't Save Settings"
    saveToggle.Size = UDim2.new(1, -20, 0, 40)
    saveToggle.Position = UDim2.new(0, 10, 0, 120)
    saveToggle.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    saveToggle.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", saveToggle).CornerRadius = UDim.new(0, 6)

    local willSave = false
    saveToggle.MouseButton1Click:Connect(function()
        willSave = not willSave
        saveToggle.Text = willSave and "Save Settings" or "Don't Save Settings"
    end)

    local continue = Instance.new("TextButton", frame)
    continue.Text = "Continue"
    continue.Size = UDim2.new(1, -20, 0, 30)
    continue.Position = UDim2.new(0, 10, 1, -40)
    continue.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    continue.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", continue).CornerRadius = UDim.new(0, 6)

    continue.MouseButton1Click:Connect(function()
        local chosen = themeCycle[index]
        self.theme = themes[chosen]
        self.darkMode = mode == "Dark"
        self.settings = {
            shouldSave = willSave,
            colorTheme = chosen,
            mode = mode
        }
        gui:Destroy()
        SaveSettings(self.settings)
        self:CreateBase()
    end)
end

return setmetatable(NovaUI, NovaUI)
