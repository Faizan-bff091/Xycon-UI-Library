-- Xycon UI Library - Minimize to Blue X Button Version
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
    local screenGui = create("ScreenGui", {
        Name = "XyconUI",
        Parent = game:GetService("CoreGui"),
        ResetOnSpawn = false
    })

    -- Main Frame
    local mainFrame = create("Frame", {
        Size = UDim2.new(0, 500, 0, 300),
        Position = UDim2.new(0.5, -250, 0.5, -150),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Name = "Main",
        Parent = screenGui
    })
    create("UICorner", {Parent = mainFrame})
    create("UIStroke", {Parent = mainFrame, Color = Color3.fromRGB(0, 255, 170)})

    -- Title Label
    local title = create("TextLabel", {
        Size = UDim2.new(1, -60, 0, 30),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = titleText or "Xycon UI",
        TextColor3 = Color3.fromRGB(0, 255, 170),
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = mainFrame
    })

    -- Close Button (X)
    local closeBtn = create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -30, 0, 0),
        Text = "X",
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        Parent = mainFrame
    })
    create("UICorner", {Parent = closeBtn})

    -- Small X button (to restore)
    local smallXBtn = create("TextButton", {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 10, 0.5, -20),
        BackgroundColor3 = Color3.fromRGB(0, 100, 255),
        Text = "X",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        Visible = false,
        Parent = screenGui
    })
    create("UICorner", {Parent = smallXBtn})

    closeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        smallXBtn.Visible = true
    end)

    smallXBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = true
        smallXBtn.Visible = false
    end)

    -- Keybind to toggle full UI with L
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.L then
            local visible = not mainFrame.Visible
            mainFrame.Visible = visible
            smallXBtn.Visible = not visible
        end
    end)

    -- Tab and content system
    local tabHolder = create("Frame", {
        Size = UDim2.new(0, 100, 1, -30),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0,
        Parent = mainFrame
    })
    create("UICorner", {Parent = tabHolder})

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
        create("UICorner", {Parent = tabButton})

        local tabPage = create("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            Parent = contentHolder
        })

        create("UIListLayout", {
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
            create("UICorner", {Parent = button})

            button.MouseButton1Click:Connect(function()
                if callback then
                    pcall(callback)
                end
            end)
        end

        return Tab
    end

    return Window
end

return UILib
