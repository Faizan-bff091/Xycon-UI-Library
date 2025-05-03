--!strict
local UILib = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local DEFAULT_KEYBIND = Enum.KeyCode.RightControl
local DEFAULT_COLOR = Color3.fromRGB(0, 255, 170)

local function create(class, props)
    local inst = Instance.new(class)
    for i, v in pairs(props) do
        inst[i] = v
    end
    return inst
end

function UILib:CreateWindow(titleText: string?, options: {Keybind: Enum.KeyCode?, ThemeColor: Color3?}?)
    local keybind = options and options.Keybind or DEFAULT_KEYBIND
    local themeColor = options and options.ThemeColor or DEFAULT_COLOR

    local screenGui = create("ScreenGui", {
        Name = "XyconUI",
        Parent = CoreGui,
        ResetOnSpawn = false
    })

    local mainFrame = create("Frame", {
        Size = UDim2.new(0, 500, 0, 300),
        Position = UDim2.new(0.5, -250, 0.5, -150),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Name = "Main",
        Parent = screenGui
    })
    create("UICorner", {Parent = mainFrame})
    create("UIStroke", {Parent = mainFrame, Color = themeColor})

    local title = create("TextLabel", {
        Size = UDim2.new(1, -50, 0, 30),
        BackgroundTransparency = 1,
        Text = titleText or "Xycon UI",
        TextColor3 = themeColor,
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        Parent = mainFrame,
        Name = "Title",
        Position = UDim2.new(0, 10, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local closeButton = create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 50, 50),
        Text = "X",
        Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        Parent = mainFrame
    })
    create("UICorner", {Parent = closeButton})

    local minimizedButton = create("TextButton", {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 10, 0.5, -20),
        BackgroundColor3 = themeColor,
        Text = "X",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        Visible = false,
        Parent = screenGui
    })
    create("UICorner", {Parent = minimizedButton})

    closeButton.MouseButton1Click:Connect(function()
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.3)
        mainFrame.Visible = false
        minimizedButton.Visible = true
    end)

    minimizedButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = true
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 500, 0, 300)}):Play()
        minimizedButton.Visible = false
    end)

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == keybind then
            screenGui.Enabled = not screenGui.Enabled
        end
    end)

    local settingsTab = create("TextButton", {
        Size = UDim2.new(0, 60, 0, 25),
        Position = UDim2.new(0, 10, 1, -30),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        Text = "⚙",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        Parent = mainFrame
    })
    create("UICorner", {Parent = settingsTab})

    settingsTab.MouseButton1Click:Connect(function()
        local msg = Instance.new("Hint", workspace)
        msg.Text = "Settings UI not yet implemented."
        task.delay(2, function()
            msg:Destroy()
        end)
    end)

    -- Future: add proper tab system, toggles, sliders, and settings

    return {
        Frame = mainFrame,
        Minimize = function()
            closeButton:Fire()
        end,
        Restore = function()
            minimizedButton:Fire()
        end,
        SetThemeColor = function(newColor: Color3)
            themeColor = newColor
            title.TextColor3 = newColor
            minimizedButton.BackgroundColor3 = newColor
        end,
        SetKeybind = function(newKeybind: Enum.KeyCode)
            keybind = newKeybind
        end
    }
end

return UILib
