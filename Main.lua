-- Xycon UI Library - Starter Version
local UILib = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function create(class, props)
    local inst = Instance.new(class)
    for i, v in pairs(props) do
        inst[i] = v
    end
    return inst
end

function UILib:CreateWindow(titleText)
    -- Main GUI Setup
    local screenGui = create("ScreenGui", {
        Name = "XyconUI",
        Parent = game:GetService("CoreGui"),
        ResetOnSpawn = false
    })

    local mainFrame = create("Frame", {
        Size = UDim2.new(0, 500, 0, 300),
        Position = UDim2.new(0.5, -250, 0.5, -150),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Parent = screenGui,
        Name = "Main"
    })

    -- Creating the top bar with title, minimize, and close buttons
    local titleBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Parent = mainFrame
    })

    local title = create("TextLabel", {
        Size = UDim2.new(1, -50, 1, 0),
        BackgroundTransparency = 1,
        Text = titleText or "Xycon UI",
        TextColor3 = Color3.fromRGB(0, 255, 170),
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        Parent = titleBar
    })

    -- Minimize Button
    local minimizeBtn = create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -30, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        Text = "-",
        Font = Enum.Font.Gotham,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        Parent = titleBar
    })
    minimizeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
    end)

    -- Close Button
    local closeBtn = create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -60, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        Text = "X",
        Font = Enum.Font.Gotham,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        Parent = titleBar
    })
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Tabs
    local tabHolder = create("Frame", {
        Size = UDim2.new(0, 100, 1, -30),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0,
        Parent = mainFrame
    })

    local tabLayout = create("UIListLayout", {
        Parent = tabHolder,
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local contentHolder = create("Frame", {
        Size = UDim2.new(1, -100, 1, -30),
        Position = UDim2.new(0, 100, 0, 30),
        BackgroundTransparency = 1,
        Parent = mainFrame
    })

    local Window = {}

    -- Create Tab function
    function Window:CreateTab(name)
        local tabButton = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            Text = name,
            Font = Enum.Font.Gotham,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 16,
            Parent = tabHolder
        })

        local tabPage = create("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            Parent = contentHolder
        })

        local layout = create("UIListLayout", {
            Parent = tabPage,
            Padding = UDim.new(0, 8)
        })

        tabButton.MouseButton1Click:Connect(function()
            for _, child in pairs(contentHolder:GetChildren()) do
                if child:IsA("Frame") then
                    child.Visible = false
                end
            end
            tabPage.Visible = true
        end)

        local Tab = {}

        -- AddButton function
        function Tab:AddButton(buttonName, callback)
            local button = create("TextButton", {
                Size = UDim2.new(1, -10, 0, 30),
                BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                Text = buttonName,
                Font = Enum.Font.Gotham,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 16,
                Parent = tabPage
            })

            button.MouseButton1Click:Connect(function()
                if callback then
                    pcall(callback)
                end
            end)
        end

        return Tab
    end

    -- Key binding to toggle visibility (L key)
    local isVisible = false
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.L then
            isVisible = not isVisible
            mainFrame.Visible = isVisible
        end
    end)

    return Window
end

return UILib
